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
    
    public class func isPossibleToStart(alreadyUsedPairs: Set<RateCurrencyPair>) -> Bool {
        let allPossible = allValidCurrencyPairs
        let remaining = allPossible.subtracting(alreadyUsedPairs)
        return remaining.count > 0
    }
    
    public init?(_ baseViewController: UIViewController, alreadyUsedPairs pairs: Set<RateCurrencyPair>) {
        guard Coordinator.isPossibleToStart(alreadyUsedPairs: pairs) else {
            return nil
        }
        
        self.baseViewController = baseViewController
        
        self.navigationController = UINavigationController()
        self.navigationController.isNavigationBarHidden = true
        
        self.firstCurrencyCoordinator = SelectCurrencyScreen.Coordinator(
            self.navigationController
            , disabledCurrency: Coordinator.leftDisabledCurrencyForPairs(pairs)
            , didSelectCurrency: { code in
                print("Did select currency \(code)")
            }
        )
    }
    
    public func start() {
        self.firstCurrencyCoordinator.start()
        self.baseViewController.present(self.navigationController, animated: true, completion: nil)
    }
    
    private class func leftDisabledCurrencyForPairs(_ pairs: Set<RateCurrencyPair>) -> Set<CurrencyCode> {
        let remainingPairs = allValidCurrencyPairs.subtracting(pairs)
        let remainingCurrency = remainingPairs.map { $0.first }
        return Set(CurrencyCode.allCases).subtracting(remainingCurrency)
    }
    
    internal let baseViewController: UIViewController
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
