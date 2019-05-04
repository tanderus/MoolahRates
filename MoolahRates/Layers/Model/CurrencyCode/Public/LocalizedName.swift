//
//  LocalizedName.swift
//  CurrencyCode
//
//  Created by Pavel Krasnobrovkin on 01/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import Foundation

public extension CurrencyCode {
    
    var localizedName: String {
        let result: String
        switch self {
        case .GBP:
            result = "Great Britain Pound"
        case .SEK:
            result = "Swedish Krona"
        case .DKK:
            result = "Danish Krone"
        case .PLN:
            result = "Polish Zloty"
        case .EUR:
            result = "Euro"
        case .NOK:
            result = "Norwegian Krone"
        case .HUF:
            result = "Hungarian Forint"
        case .CZK:
            result = "Czech Koruna"
        case .USD:
            result = "United States Dollar"
        case .RUB:
            result = "Russian Ruble"
        case .SGD:
            result = "Singapore Dollar"
        case .HKD:
            result = "Hong Kong Dollar"
        }
        
        return BundleWrapper.bundle.localizedString(forKey: result, value: nil, table: nil)
    }
}
