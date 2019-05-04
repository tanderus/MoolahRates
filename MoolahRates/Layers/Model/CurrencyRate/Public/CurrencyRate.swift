//
//  CurrencyRate.swift
//  CurrencyRate
//
//  Created by Pavel Krasnobrovkin on 02/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import CurrencyCode

public struct CurrencyRate: Hashable {
    
    public init?(_ first: CurrencyCode, second: CurrencyCode, rate: Decimal) {
        guard let pair = RateCurrencyPair(first: first, second: second) else {
            return nil
        }
        
        self.init(pair, rate: rate)
    }
    
    public init?(_ firstCode: String, secondCode: String, rate: Decimal) {
        guard let pair = RateCurrencyPair(firstCode: firstCode, secondCode: secondCode) else {
            return nil
        }
        
        self.init(pair, rate: rate)
    }
    
    public init(_ pair: RateCurrencyPair, rate: Decimal) {
        self.first = pair.first
        self.second = pair.second
        self.rate = rate
    }
    
    public var currencyPair: RateCurrencyPair {
        return RateCurrencyPair(first: self.first, second: self.second)!
    }
    
    public let first: CurrencyCode
    public let second: CurrencyCode
    public let rate: Decimal
}
