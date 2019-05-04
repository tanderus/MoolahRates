//
//  ExchangeRateCell.swift
//  HomeScreen
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import UIKit
import CurrencyRate

class ExchangeRateCell: UITableViewCell {
    
    @IBOutlet private weak var baseCurrencyCountLabel: UILabel!
    @IBOutlet private weak var baseCurrencyNameLabel: UILabel!
    
    @IBOutlet private weak var rateLabel: UILabel!
    @IBOutlet private weak var secondCurrencyNameLabel: UILabel!
    
    func configureWithRate(_ rate: CurrencyRate) {
        self.baseCurrencyCountLabel.text = "1 \(rate.first)"
        self.baseCurrencyNameLabel.text = rate.first.localizedName
        
        self.rateLabel.text = rateFormatter.string(from: rate.rate as NSDecimalNumber)!
        self.secondCurrencyNameLabel.text = rate.second.localizedName + " • \(rate.second)"
    }
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
