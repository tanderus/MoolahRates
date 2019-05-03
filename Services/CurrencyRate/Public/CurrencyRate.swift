//
//  CurrencyRate.swift
//  CurrencyRate
//
//  Created by Pavel Krasnobrovkin on 02/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import CurrencyCode

public struct CurrencyRate {
    
    public init?(_ first: CurrencyCode, second: CurrencyCode, rate: Decimal) {
        guard first != second else {
            return nil
        }
        
        self.first = first
        self.second = second
        self.rate = rate
    }
    
    public init?(_ firstCode: String, secondCode: String, rate: Decimal) {
        guard let pair = CurrencyPair(firstCode: firstCode, secondCode: secondCode) else {
            return nil
        }
        
        self.init(pair, rate: rate)
    }
    
    public init?(_ pair: CurrencyPair, rate: Decimal) {
        self.init(pair.first, second: pair.second, rate: rate)
    }
    
    public let first: CurrencyCode
    public let second: CurrencyCode
    public let rate: Decimal
}
