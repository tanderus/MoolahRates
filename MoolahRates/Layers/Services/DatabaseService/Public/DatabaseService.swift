//
//  DatabaseService.swift
//  DatabaseService
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import CurrencyRate
import CurrencyCode

public protocol DatabaseService {
    
    func addObserver(_ observer: DatabaseObserver)
    func removeObserver(_ observer: DatabaseObserver)
    
    func initialize(completion: @escaping (Result<[CurrencyRate], DatabaseError>) -> Void)
    
    
    var latestRatesSorted: [CurrencyRate] { get }
    
    func createNewRate(
        _ rate: CurrencyRate
        , completion: @escaping (Result<CurrencyRate, RateAddingError>) -> Void
    )
    
    func updateRateWith(
        _ newRate: CurrencyRate
        , completion: @escaping (Result<CurrencyRate, RateUpdateError>) -> Void
    )
    
    func deleteRate(
        _ rate: CurrencyRate
        , completion: @escaping (Result<CurrencyRate, RateDeletionError>) -> Void
    )
}

public func createNewDatabaseService() -> DatabaseService {
    return DatabaseImplementation()
}
