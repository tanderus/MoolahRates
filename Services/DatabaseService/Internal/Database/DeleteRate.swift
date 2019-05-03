//
//  DeleteRate.swift
//  DatabaseService
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import CoreData

import CurrencyCode
import CurrencyRate

extension DatabaseImplementation {
    
    func privateDeleteRate(
        _ rate: CurrencyRate
        , completion: @escaping (Result<CurrencyRate, RateDeletionError>) -> Void
        ) {
        DispatchQueue.main.async {
            let predicate = { (entity: Rate) -> Bool in
                return rate.first.rawValue == entity.firstCode && rate.second.rawValue == entity.secondCode
            }
            
            guard let entity = self.rateEntitiesSorted.first(where: predicate) else {
                completion(.failure(.RateWasNotInStore))
                return
            }
            
            let context = self.persistentContainer.viewContext
            context.delete(entity)
            do {
                try context.save()
            }
            catch {
                completion(.failure(.FailedToSave))
                return
            }
            
            completion(.success(rate))
        }
    }
}
