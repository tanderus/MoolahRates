//
//  CurrencyCode.swift
//  CurrencyCode
//
//  Created by Pavel Krasnobrovkin on 01/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import Foundation

public enum CurrencyCode: String, RawRepresentable, CaseIterable {
    
    case GBP
    case SEK
    case DKK
    case PLN
    case EUR
    case NOK
    case HUF
    case CZK
    case USD
    case RUB
    case SGD
    case HKD
    
    public static var allCasesSet: Set<CurrencyCode> {
        return Set(self.allCases)
    }
}
