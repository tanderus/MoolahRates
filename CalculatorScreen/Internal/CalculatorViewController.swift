//
//  CalculatorViewController.swift
//  CalculatorScreen
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import UIKit
import StoryboardInstantiatable

final class CalculatorViewController: UIViewController, StoryboardInstantiatable {
    
    @IBOutlet private weak var baseCurrencyCount: UILabel!
    @IBOutlet private weak var baseCurrencyStepper: UIStepper!
    
    @IBOutlet private weak var exchangeRate: UILabel!
    @IBOutlet private weak var resultLabel: UILabel!
    
    @IBAction private func didChangeValueBaseCurrencyStepper() {
        
    }
    
    @IBAction private func didTapDoneButton() {
        
    }
}
