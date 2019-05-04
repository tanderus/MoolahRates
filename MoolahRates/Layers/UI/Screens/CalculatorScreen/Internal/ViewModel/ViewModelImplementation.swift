//
//  ViewModelImplementation.swift
//  CalculatorScreen
//
//  Created by Pavel Krasnobrovkin on 04/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import RxCocoa
import RxSwift

final class ViewModelImplementation: ViewModel {
    
    var baseCurrencyCount: Observable<Double> {
        return _baseCurrencyCount.asObservable()
    }
    var formattedBaseCurrencyCount: Observable<String> {
        return _formattedBaseCurrencyCount.asObservable()
    }
    var formattedRate: Observable<String> {
        return _formattedRate.asObservable()
    }
    var formattedResult: Observable<String> {
        return _formattedResult.asObservable()
    }
    
    init(_ model: Model) {
        self.model = model
        
        model.baseCurrencyCount
            .bind(to: self._baseCurrencyCount)
            .disposed(by: self.disposeBag)
        
        model.baseCurrencyCount
            .withLatestFrom(model.rate) { return ($0, $1.first) }
            .map { String(format: "%1.2f \($0.1)", $0.0) }
            .bind(to: self._formattedBaseCurrencyCount)
            .disposed(by: self.disposeBag)
        
        model.rate
            .map { rateFormatter.string(from: $0.rate as NSDecimalNumber) ?? "" }
            .bind(to: self._formattedRate)
            .disposed(by: self.disposeBag)
        
        model.result
            .withLatestFrom(model.rate) { return ($0, $1.second) }
            .map {
                let code = "\($0.1)"
                guard let formattedValue = rateFormatter.string(from: $0.0 as NSDecimalNumber) else {
                    return code
                }
                return formattedValue + " " + code
            }
            .bind(to: self._formattedResult)
            .disposed(by: disposeBag)
    }
    
    internal let model: Model
    internal let disposeBag = DisposeBag()
    
    internal let _baseCurrencyCount = BehaviorRelay(value: 0.01)
    internal let _formattedBaseCurrencyCount = BehaviorRelay(value: "")
    internal let _formattedRate = BehaviorRelay(value: "")
    internal let _formattedResult = BehaviorRelay(value: "")
}

fileprivate let rateFormatter: NumberFormatter = {
    let result = NumberFormatter()
    result.minimumIntegerDigits = 1
    
    result.minimumFractionDigits = 4
    result.maximumFractionDigits = 4
    
    result.alwaysShowsDecimalSeparator = true
    result.decimalSeparator = "."
    result.currencyDecimalSeparator = "."
    return result
}()
