//
//  UpdateRateWith.swift
//  DatabaseService
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import CoreData

import CurrencyRate

extension DatabaseImplementation {
    
    func privateUpdateRateWith(
        _ rate: CurrencyRate
        , completion: @escaping (Result<CurrencyRate, RateUpdateError>) -> Void
        ) {
        DispatchQueue.main.async {
            let predicate = { (entity: Rate) -> Bool in
                return rate.first.rawValue == entity.firstCode && rate.second.rawValue == entity.secondCode
            }
            
            guard let entity = self.rateEntitiesSorted.first(where: predicate) else {
                completion(.failure(.RateNotInStore))
                return
            }
            
            let context = self.persistentContainer.viewContext
            entity.ratio = rate.rate as NSDecimalNumber
            do {
                try context.save()
            }
            catch {
                completion(.failure(.FailedToSave))
                return
            }
            
            self.observers.forEach { $0.database(self, didChangeRateTo: rate) }
            completion(.success(rate))
        }
    }
}
