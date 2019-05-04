//
//  CurrencyRateTests.swift
//  MoolahRatesTests
//
//  Created by Pavel Krasnobrovkin on 02/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import XCTest
import CurrencyCode
import CurrencyRate

class CurrencyRateTests: XCTestCase {
    
    func testInitializationWithSameCurrency() {
        let rate = Decimal(string: "1.3456")!
        let EUR = CurrencyCode.EUR
        
        XCTAssertNil(
            CurrencyRate(EUR, second: EUR, rate: rate)
            , "Shouldn't initialize for the same currency"
        )
        XCTAssertNil(
            CurrencyRate("\(EUR)", secondCode: "\(EUR)", rate: rate)
            , "Shouldn't initialize for the same currency"
        )
    }
    
    func testInitializationWithUnsupportedCurrency() {
        let rate = Decimal(string: "1.3456")!
        let EUR = CurrencyCode.EUR
        
        XCTAssertNil(
            CurrencyRate("LOL", secondCode: "\(EUR)", rate: rate)
            , "Shouldn't initialize for unsupported currency"
        )
        XCTAssertNil(
            CurrencyRate("\(EUR)", secondCode: "OMG", rate: rate)
            , "Shouldn't initialize for unsupported currency"
        )
    }
    
    func testInitializationWithValidCurrency() {
        let rate = Decimal(string: "1.3456")!
        let EUR = CurrencyCode.EUR
        let RUB = CurrencyCode.RUB
        
        XCTAssertNotNil(
            CurrencyRate(EUR, second: RUB, rate: rate)
            , "Should initialize normally"
        )
        XCTAssertNotNil(
            CurrencyRate("\(EUR)", secondCode: "\(RUB)", rate: rate)
            , "Should initialize normally"
        )
        
        let pair = RateCurrencyPair(first: EUR, second: RUB)
        XCTAssertNotNil(pair, "Should initialize normally")
    }
}
