//
//  Coordinator.swift
//  SelectCurrencyPairFlow
//
//  Created by Pavel Krasnobrovkin on 04/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import CurrencyCode
import SelectCurrencyScreen

import UIKit

public final class Coordinator {
    
    public class func isPossibleToStart(alreadyUsedPairs: Set<CurrencyPair>) -> Bool {
        let allPossible = allPossibleCurrencyPairs
        let remaining = allPossible.subtracting(alreadyUsedPairs)
        return remaining.count > 0
    }
    
    public init?(_ baseViewController: UIViewController, alreadyUsedPairs pairs: Set<CurrencyPair>) {
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
    
    private class func leftDisabledCurrencyForPairs(_ pairs: Set<CurrencyPair>) -> Set<CurrencyCode> {
        let remainingPairs = allPossibleCurrencyPairs.subtracting(pairs)
        let remainingCurrency = remainingPairs.map { $0.first }
        return Set(CurrencyCode.allCases).subtracting(remainingCurrency)
    }
    
    internal let baseViewController: UIViewController
    internal let navigationController: UINavigationController
    
    internal let firstCurrencyCoordinator: SelectCurrencyScreen.Coordinator
    internal var secondCurrencyCoordinator: SelectCurrencyScreen.Coordinator?
}


internal let allPossibleCurrencyPairs: Set<CurrencyPair> = {
    var result = Set<CurrencyPair>()
    
    let allCurrencies = CurrencyCode.allCases
    allCurrencies.forEach { first in
        allCurrencies.forEach { second in
            guard first != second else {
                return
            }
            
            result.insert(CurrencyPair(first: first, second: second))
        }
    }
    
    return result
}()
