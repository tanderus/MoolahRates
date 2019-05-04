//
//  SelectCurrencyPairTests.swift
//  MoolahRatesTests
//
//  Created by Pavel Krasnobrovkin on 04/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import XCTest

import CurrencyCode
@testable import SelectCurrencyPairFlow

class SelectCurrencyPairTests: XCTestCase {
    
    func testAllValidCurrencyPairs() {
        let nPairs = allPossibleCurrencyPairs.count
        let nCurrencies = CurrencyCode.allCases.count
        XCTAssert(nPairs == nCurrencies * (nCurrencies - 1))
        XCTAssertFalse(allPossibleCurrencyPairs.contains(
            where: { $0.first == $0.second })
            , "Shouldn't be possible to create a rate-pair with the same currency"
        )
    }
    
    func testIfPossibletoStartWithAllPairsUsed() {
        let allPairs = allPossibleCurrencyPairs
        let flag = SelectCurrencyPairFlow.Coordinator.isPossibleToStart(alreadyUsedPairs: allPairs)
        XCTAssertFalse(flag, "Shouldn't be possible to run flow if all possible rates are already created")
    }
}
