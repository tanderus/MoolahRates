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
    
    public init(_ baseViewController: UIViewController) {
        self.baseViewController = baseViewController
        
        self.navigationController = UINavigationController()
        self.navigationController.isNavigationBarHidden = true
        
        self.firstCurrencyCoordinator = SelectCurrencyScreen.Coordinator(
            self.navigationController
            , didSelectCurrency: { code in
                print("Did select currency \(code)")
            }
            , shouldPushOnStart: false
        )
    }
    
    public func start() {
        self.firstCurrencyCoordinator.start()
        self.baseViewController.present(self.navigationController, animated: true, completion: nil)
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
