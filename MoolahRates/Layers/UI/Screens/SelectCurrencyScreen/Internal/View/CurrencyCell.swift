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
    
    func configureWithCurrencyName(_ name: String, countryFlag: UIImage, isDisabled: Bool) {
        self.currencyNameLabel.text = name
        self.accessibilityHint = name
        self.accessibilityLabel = name
        
        self.countryFlagImage.image = countryFlag
        
        self.selectionStyle = .default
        var alpha: CGFloat = 1
        if isDisabled {
            self.selectionStyle = .none
            alpha = 0.6
        }
        
        self.countryFlagImage.alpha = alpha
        self.currencyNameLabel.alpha = alpha
    }
}
