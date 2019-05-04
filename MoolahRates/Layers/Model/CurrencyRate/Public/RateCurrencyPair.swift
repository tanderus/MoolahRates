//
//  RateCurrencyPair.swift
//  CurrencyRate
//
//  Created by Pavel Krasnobrovkin on 04/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import CurrencyCode

public struct RateCurrencyPair: Hashable {
    
    public init?(first: CurrencyCode, second: CurrencyCode) {
        guard first != second else { return nil }
        
        self.first = first
        self.second = second
    }
    
    public init?(firstCode: String, secondCode: String) {
        guard let first = CurrencyCode(rawValue: firstCode) else {
            return nil
        }
        
        guard let second = CurrencyCode(rawValue: secondCode) else {
            return nil
        }
        
        self.init(first: first, second: second)
    }
    
    public let first: CurrencyCode
    public let second: CurrencyCode
}
