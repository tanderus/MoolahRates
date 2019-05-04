//
//  ViewModel.swift
//  CalculatorScreen
//
//  Created by Pavel Krasnobrovkin on 04/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ViewModel {
    
    var baseCurrencyCount: Observable<Double> { get }
    var formattedBaseCurrencyCount: Observable<String> { get }
    var formattedRate: Observable<String> { get }
    var formattedResult: Observable<String> { get }
}
