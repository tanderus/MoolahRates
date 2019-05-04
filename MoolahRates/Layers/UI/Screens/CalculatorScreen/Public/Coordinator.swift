//
//  Coordinator.swift
//  CalculatorScreen
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import UIKit

import CurrencyRate
import DatabaseService

public final class Coordinator {
    
    public var didTapDone: (() -> Void)!
    
    public init(_ baseViewController: UIViewController, rate: CurrencyRate, database: DatabaseService) {
        self.baseViewController = baseViewController
        
        let viewController = CalculatorViewController.instantiateViaStoryboard()
        self.viewController = viewController
        
        let model = ModelImplementation(rate: rate, observeDatabase: database)
        let viewModel = ViewModelImplementation(model)
        viewController.viewModel = viewModel
        
        viewController.didChangeBaseCurrencyValue = { [weak model] newValue in
            model?.setBaseCurrencyCount(newValue)
        }
    }
    
    public func start() {
        self.viewController.didTapDone = self.didTapDone
        
        self.baseViewController.present(self.viewController, animated: true, completion: nil)
    }
    
    internal let baseViewController: UIViewController
    internal let viewController: CalculatorViewController
}
