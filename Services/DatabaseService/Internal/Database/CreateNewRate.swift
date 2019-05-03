//
//  CreateNewRate.swift
//  DatabaseService
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import CoreData

import CurrencyRate

extension DatabaseImplementation {
    
    func privateCreateNewRate(
        _ rate: CurrencyRate
        , completion: @escaping (Result<CurrencyRate, RateAddingError>) -> Void
        ) {
        DispatchQueue.main.async {
            if self.latestRatesSorted.contains(where: { $0.first == rate.first && $0.second == rate.second }) {
                completion(.failure(.RateAlreadyExists))
                return
            }
            
            let context = self.persistentContainer.viewContext
            let newRate = Rate(context: context)
            newRate.createdAt = NSDate()
            newRate.firstCode = rate.first.rawValue
            newRate.secondCode = rate.second.rawValue
            newRate.ratio = rate.rate as NSDecimalNumber
            
            self.ratesOrder.addToSortedRates(newRate)
            
            do {
                try context.save()
            }
            catch {
                completion(.failure(.FailedToSave))
                return
            }
            
            self.observers.forEach { $0.database(self, didCreateRate: rate) }
            completion(.success(rate))
        }
    }
}
