//
//  ExchangeRateCell.swift
//  HomeScreen
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import UIKit

class ExchangeRateCell: UITableViewCell {
    
    @IBOutlet private weak var baseCurrencyCountLabel: UILabel!
    @IBOutlet private weak var baseCurrencyNameLabel: UILabel!
    
    @IBOutlet private weak var rateLabel: UILabel!
    @IBOutlet private weak var secondCurrencyNameLabel: UILabel!
}
