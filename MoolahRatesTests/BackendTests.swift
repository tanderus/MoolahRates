//
//  BackendTests.swift
//  MoolahRatesTests
//
//  Created by Pavel Krasnobrovkin on 04/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import XCTest

import CurrencyCode
import CurrencyRate
import BackendService

class BackendTests: XCTestCase {
    
    func testPassingEmptyArray() {
        let expect = expectation(description: "Should receive wrong arguments error")
        
        self.backend.downloadLatestRatesForPairs(currencyPairs: [], endpoint: .RATES_IO) { result in
            switch result {
            case let .failure(error):
                if error == .WrongArguments {
                    expect.fulfill()
                }
            case .success:
                break
            }
        }
        
        wait(for: [expect], timeout: 10)
    }
    
    func testPassingPairsWithSameCurrencies() {
        let wrongPairForRate = CurrencyPair(first: .RUB, second: .RUB)
        let validPair = CurrencyPair(first: .USD, second: .RUB)
        
        let expect = expectation(description: "Should receive wrong arguments error")
        self.backend.downloadLatestRatesForPairs(currencyPairs: [validPair, wrongPairForRate], endpoint: .RATES_IO) { result in
            switch result {
            case let .failure(error):
                if error == .WrongArguments {
                    expect.fulfill()
                }
            case .success:
                break
            }
        }
        
        wait(for: [expect], timeout: 10)
    }
    
    func testPassingOneValidPair() {
        let pair = CurrencyPair(first: .USD, second: .RUB)
        
        let expect = expectation(description: "Should receive rate normally")
        self.backend.downloadLatestRatesForPairs(currencyPairs: [pair], endpoint: .RATES_IO) { result in
            switch result {
            case let .failure(error):
                print("Failed to receive rate: '\(error.localizedDescription)'")
                
            case let .success(rates):
                XCTAssert(rates.count == 1, "Should receive result of the same size as the input")
                
                let rate = rates.first!
                XCTAssert(rate.first == pair.first, "The base currency should be the same")
                XCTAssert(rate.second == pair.second, "The target currency should be the same")
                expect.fulfill()
            }
        }
        
        wait(for: [expect], timeout: 10)
    }
    
    func testPassingSeveralValidPairs() {
        let pairsRequired = Set([
            CurrencyPair(first: .USD, second: .RUB)
            , CurrencyPair(first: .USD, second: .EUR)
            , CurrencyPair(first: .RUB, second: .EUR)
            , CurrencyPair(first: .EUR, second: .USD)
            , CurrencyPair(first: .EUR, second: .RUB)
            ]
        )
        
        let expect = expectation(description: "Should receive rates normally")
        self.backend.downloadLatestRatesForPairs(currencyPairs: pairsRequired, endpoint: .RATES_IO) { result in
            switch result {
            case let .failure(error):
                print("Failed to receive rate: '\(error.localizedDescription)'")
                
            case let .success(rates):
                XCTAssert(rates.count == pairsRequired.count, "Should receive result of the same size as the input")
                
                print("Received rates: \(pairsRequired.count)")
                rates.forEach { print("\($0.first) / \($0.second) IS '\($0.rate)'") }
                
                for receivedRate in rates {
                    let pair = CurrencyPair(first: receivedRate.first, second: receivedRate.second)
                    if !pairsRequired.contains(pair) {
                        XCTFail("Didn't receive rate for \(pair.first) / \(pair.second)")
                        return
                    }
                }
                
                expect.fulfill()
            }
        }
        
        wait(for: [expect], timeout: 10)
    }
    
    private let backend = CreateNewBackendInstance()
}
