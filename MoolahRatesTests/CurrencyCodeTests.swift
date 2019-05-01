//
//  CurrencyCodeTests.swift
//  MoolahRatesTests
//
//  Created by Pavel Krasnobrovkin on 01/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import XCTest
import CurrencyCode

class CurrencyCodeTests: XCTestCase {

    func testCurrencyPairsEquality() {
        let usdRub1 = CurrencyPair(firstCode: "USD", secondCode: "RUB")
        XCTAssertNotNil(usdRub1, "USD/RUB pair should instantiate normally")
        
        let usdRub2 = CurrencyPair(first: .USD, second: .RUB)
        XCTAssert(usdRub1 == usdRub2, "Should be equal")
        
        let pairsSet = Set(arrayLiteral: usdRub1, usdRub2)
        XCTAssert(pairsSet.count == 1, "Should remove equal pairs as CurrencyPair is hashable")
    }
    
    func testCurrencyCodeDescription() {
        let CZK = CurrencyCode.CZK
        let RUB = CurrencyCode.RUB
        
        XCTAssert("\(CZK)" == "CZK", "CurrencyCode.CZK.description should be equal to 'CZK'")
        XCTAssert("\(RUB)" == "RUB", "CurrencyCode.RUB.description should be equal to 'RUB'")
    }

}
