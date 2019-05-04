//
//  CalculatorViewController.swift
//  CalculatorScreen
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import UIKit
import StoryboardInstantiatable

import RxCocoa
import RxSwift

final class CalculatorViewController: UIViewController, StoryboardInstantiatable {
    
    var viewModel: ViewModel!
    var didChangeBaseCurrencyValue: ((Double) -> Void)!
    var didTapDone: (() -> Void)!
    
    @IBOutlet private weak var baseCurrencyCount: UILabel!
    @IBOutlet private weak var baseCurrencyStepper: UIStepper!
    
    @IBOutlet private weak var exchangeRate: UILabel!
    @IBOutlet private weak var resultLabel: UILabel!
    
    @IBAction private func didChangeValueBaseCurrencyStepper() {
        let newValue = self.baseCurrencyStepper.value
        self.didChangeBaseCurrencyValue(newValue)
    }
    
    @IBAction private func didTapDoneButton() {
        self.didTapDone()
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.baseCurrencyCount
            .bind(to: self.baseCurrencyStepper.rx.value)
            .disposed(by: self.disposeBag)
        
        self.viewModel.formattedBaseCurrencyCount
            .bind(to: self.baseCurrencyCount.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel.formattedRate
            .bind(to: self.exchangeRate.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel.formattedResult
            .bind(to: self.resultLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
}
