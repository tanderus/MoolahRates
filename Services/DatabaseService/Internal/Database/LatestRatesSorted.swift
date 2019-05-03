//
//  LatestRatesSorted.swift
//  DatabaseService
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import CurrencyRate

import CoreData

extension DatabaseImplementation {
    
    var ratesOrder: RatesOrder {
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<RatesOrder> = RatesOrder.fetchRequest()
        let objects = try! context.fetch(request)
        return objects.first!
    }
    
    var rateEntitiesSorted: [Rate] {
        return self.ratesOrder
            .sortedRates
            .compactMap { $0 as? Rate }
    }
    
    var privateLatestRatesSorted: [CurrencyRate] {
        return self.rateEntitiesSorted
            .compactMap { CurrencyRate(rate: $0) }
    }
}
