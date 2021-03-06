//
//  SelectCurrencyPairTests.swift
//  MoolahRatesTests
//
//  Created by Pavel Krasnobrovkin on 04/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import XCTest

import CurrencyCode
import CurrencyRate
@testable import SelectCurrencyPairFlow

class SelectCurrencyPairTests: XCTestCase {
    
    func testAllValidCurrencyPairs() {
        let nPairs = allValidCurrencyPairs.count
        let nCurrencies = CurrencyCode.allCases.count
        XCTAssert(nPairs == nCurrencies * (nCurrencies - 1))
        XCTAssertFalse(allValidCurrencyPairs.contains(
            where: { $0.first == $0.second })
            , "Shouldn't be possible to create a rate-pair with the same currency"
        )
    }
    
    func testIfPossibletoStartWithAllPairsUsed() {
        let allPairs = allValidCurrencyPairs
        let flag = SelectCurrencyPairFlow.Coordinator.isPossibleToStart(alreadyUsedPairs: allPairs)
        XCTAssertFalse(flag, "Shouldn't be possible to run flow if all possible rates are already created")
    }
    
    func testIfPossibleToStartWithOnlyOnePair() {
        guard let pair = RateCurrencyPair(first: .EUR, second: .USD) else {
            XCTFail("Should initialize normally")
            return
        }
        
        let flag = SelectCurrencyPairFlow.Coordinator.isPossibleToStart(alreadyUsedPairs: [pair])
        XCTAssertTrue(flag, "Should be possible to start")
    }
}
