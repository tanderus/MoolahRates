//
//  RatesUpdater.swift
//  HomeScreen
//
//  Created by Pavel Krasnobrovkin on 04/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import DatabaseService
import BackendService

final class RatesUpdater {
    
    internal let database: DatabaseService
    internal let backend: BackendService
    
    internal var updatingTimer: Timer? = nil
    
    init(_ database: DatabaseService, backend: BackendService) {
        self.database = database
        self.backend = backend
    }
    
    func startUpdatingRates() {
        self.invalidateTimer()
        self.updatingTimer = Timer.scheduledTimer(
            timeInterval: 5
            , target: self, selector: #selector(self.timerFired)
            , userInfo: nil
            , repeats: true
        )
    }
    
    @objc private func timerFired() {
        let pairs = self.database.latestRatesSorted.map { $0.currencyPair }
        self.backend.downloadLatestRatesForPairs(currencyPairs: Set(pairs), endpoint: .RATES_IO) { result in
            switch result {
            case .failure:
                break
                
            case let .success(newRates):
                newRates.forEach { [weak self] newRate in
                    self?.database.updateRateWith(newRate) { _ in }
                }
            }
        }
    }
    
    private func invalidateTimer() {
        self.updatingTimer?.invalidate()
        self.updatingTimer = nil
    }
    
    deinit {
        self.invalidateTimer()
    }
}
