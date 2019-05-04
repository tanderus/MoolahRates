//
//  Model.swift
//  CalculatorScreen
//
//  Created by Pavel Krasnobrovkin on 04/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import CurrencyRate

import RxSwift
import RxCocoa

protocol Model {
    
    var rate: Observable<CurrencyRate> { get }
    var baseCurrencyCount: Observable<Double> { get }
    var result: Observable<Decimal> { get }
    
    func setBaseCurrencyCount(_ value: Double)
}
