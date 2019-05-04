//
//  Initialize.swift
//  DatabaseService
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import CurrencyRate

import CoreData

extension DatabaseImplementation {
    
    func privateInitialize(completion: @escaping (Result<[CurrencyRate], DatabaseError>) -> Void) {
        DispatchQueue.main.async {
            let fileManager = FileManager.default
            let directoryUrl = fileManager.storeDirectoryUrl!
            
            let availableDiskSpaceBytes: Int64
            do {
                let values = try directoryUrl.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
                guard let capacity = values.volumeAvailableCapacityForImportantUsage else {
                    completion(.failure(.InternalError))
                    return
                }
                
                availableDiskSpaceBytes = capacity
            }
            catch {
                completion(.failure(.InternalError))
                return
            }
            
            let requiredDiskSpaceBytes = 10 * 1024 * 1024
            guard availableDiskSpaceBytes >= requiredDiskSpaceBytes else {
                completion(.failure(.NotEnoughDiskSpace(requiredDiskSpaceBytes: requiredDiskSpaceBytes)))
                return
            }
            
            self.persistentContainer.loadPersistentStores { (_, error) in
                if let _ = error {
                    completion(.failure(.InternalError))
                }
                
                let context = self.persistentContainer.viewContext
                let request: NSFetchRequest<RatesOrder> = RatesOrder.fetchRequest()
                do {
                    let objects = try context.fetch(request)
                    if objects.first == nil {
                        let _ = RatesOrder(context: context)
                        try context.save()
                    }
                }
                catch {
                    completion(.failure(.InternalError))
                    return
                }
                
                let latestRates = self.latestRatesSorted
                completion(.success(latestRates))
            }
        }
    }
}
