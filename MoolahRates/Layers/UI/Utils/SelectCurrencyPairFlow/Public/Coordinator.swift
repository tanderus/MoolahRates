//
//  Coordinator.swift
//  SelectCurrencyPairFlow
//
//  Created by Pavel Krasnobrovkin on 04/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import CurrencyCode
import CurrencyRate
import SelectCurrencyScreen

import UIKit

public final class Coordinator {
    
    public var didSelectCurrencyPair: ((RateCurrencyPair) -> Void)!
    
    public class func isPossibleToStart(alreadyUsedPairs: Set<RateCurrencyPair>) -> Bool {
        let allValid = allValidCurrencyPairs
        let remaining = allValid.subtracting(alreadyUsedPairs)
        return remaining.count > 0
    }
    
    public init?(_ baseViewController: UIViewController, alreadyUsedPairs pairs: Set<RateCurrencyPair>) {
        guard Coordinator.isPossibleToStart(alreadyUsedPairs: pairs) else {
            return nil
        }
        
        self.baseViewController = baseViewController
        self.alreadyUsedPairs = pairs
        
        self.navigationController = UINavigationController()
        self.navigationController.isNavigationBarHidden = true
        
        self.firstCurrencyCoordinator = SelectCurrencyScreen.Coordinator(
            self.navigationController
            , disabledCurrency: Coordinator.leftDisabledCurrencyForPairs(pairs)
        )
        
        self.firstCurrencyCoordinator.didSelectCurrency = self.didSelectFirstCurrency
    }
    
    public func start() {
        self.firstCurrencyCoordinator.start()
        self.baseViewController.present(self.navigationController, animated: true, completion: nil)
    }
    
    private class func leftDisabledCurrencyForPairs(_ pairs: Set<RateCurrencyPair>) -> Set<CurrencyCode> {
        let remainingPairs = allValidCurrencyPairs.subtracting(pairs)
        let remainingCurrency = remainingPairs.map { $0.first }
        return CurrencyCode.allCasesSet.subtracting(remainingCurrency)
    }
    
    private class func rightDisabledCurrencyForPairs(_ pairs: Set<RateCurrencyPair>, firstCurrency: CurrencyCode) -> Set<CurrencyCode> {
        let remainingPairs = allValidCurrencyPairs.subtracting(pairs)
        let remainingWithFirst = remainingPairs.filter { $0.first == firstCurrency }
        let enabled = Set(remainingWithFirst.map { $0.second })
        return CurrencyCode.allCasesSet.subtracting(enabled)
    }
    
    private func didSelectFirstCurrency(_ firstCurrency: CurrencyCode) {
        let disabled = Coordinator.rightDisabledCurrencyForPairs(
            self.alreadyUsedPairs
            , firstCurrency: firstCurrency
        )
        
        self.secondCurrencyCoordinator = SelectCurrencyScreen.Coordinator(
            self.navigationController
            , disabledCurrency: disabled
            , shouldPushOnStart: true
        )
        self.secondCurrencyCoordinator?.didSelectCurrency = { [weak self] second in
            let pair = RateCurrencyPair(first: firstCurrency, second: second)!
            self?.didSelectCurrencyPair(pair)
        }
        self.secondCurrencyCoordinator?.start()
    }
    
    internal let baseViewController: UIViewController
    internal let alreadyUsedPairs: Set<RateCurrencyPair>
    
    internal let navigationController: UINavigationController
    
    internal let firstCurrencyCoordinator: SelectCurrencyScreen.Coordinator
    internal var secondCurrencyCoordinator: SelectCurrencyScreen.Coordinator?
}


internal let allValidCurrencyPairs: Set<RateCurrencyPair> = {
    var result = Set<RateCurrencyPair>()
    
    let allCurrencies = CurrencyCode.allCases
    allCurrencies.forEach { first in
        result.formUnion(
            allCurrencies.compactMap { RateCurrencyPair(first: first, second: $0) }
        )
    }
    
    return result
}()
