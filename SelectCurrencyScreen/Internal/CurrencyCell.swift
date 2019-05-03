//
//  CurrencyCell.swift
//  SelectCurrencyScreen
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import UIKit

final class CurrencyCell: UITableViewCell {
    
    @IBOutlet private weak var countryFlagImage: UIImageView!
    @IBOutlet private weak var currencyNameLabel: UILabel!
    
    func configureWithCurrencyName(_ name: String, countryFlag: UIImage) {
        self.currencyNameLabel.text = name
        self.accessibilityHint = name
        self.accessibilityLabel = name
        
        self.countryFlagImage.image = countryFlag
    }
}
