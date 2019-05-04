//
//  ModelImplementation.swift
//  CalculatorScreen
//
//  Created by Pavel Krasnobrovkin on 04/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import RxCocoa
import RxSwift

import CurrencyRate
import DatabaseService

final class ModelImplementation: Model {
    
    var rate: Observable<CurrencyRate> {
        return _rate.asObservable()
    }
    
    var baseCurrencyCount: Observable<Double> {
        return _baseCurrencyCount.asObservable()
    }
    
    var result: Observable<Decimal> {
        return _result.asObservable()
    }
    
    init(rate: CurrencyRate, observeDatabase database: DatabaseService) {
        self._rate = BehaviorRelay(value: rate)
        self._baseCurrencyCount = BehaviorRelay(value: 1)
        self._result = BehaviorRelay(value: rate.rate)
        
        database.addObserver(self)
    }
    
    func setBaseCurrencyCount(_ value: Double) {
        self._baseCurrencyCount.accept(value)
        self.updateCalculations()
    }
    
    private var _rate: BehaviorRelay<CurrencyRate>
    private var _baseCurrencyCount: BehaviorRelay<Double>
    private var _result: BehaviorRelay<Decimal>
}

extension ModelImplementation: DatabaseObserver {
    
    func database(_ database: DatabaseService, didCreateRate rate: CurrencyRate) {}
    
    func database(_ database: DatabaseService, didDeleteRate rate: CurrencyRate) {}
    
    func database(_ database: DatabaseService, didChangeRateTo newRate: CurrencyRate) {
        let slot = self._rate
        guard slot.value.currencyPair == newRate.currencyPair else {
            return
        }
        
        slot.accept(newRate)
        self.updateCalculations()
    }
    
    fileprivate func updateCalculations() {
        let baseCount = _baseCurrencyCount.value
        let count = Decimal(baseCount)
        
        let rate = _rate.value
        self._result.accept(count * rate.rate)
    }
}
