//
//  DatabaseTests.swift
//  MoolahRatesTests
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import XCTest
import CoreData

import CurrencyCode
import CurrencyRate
@testable import DatabaseService

class DatabaseTests: XCTestCase {
    
    override func setUp() {
        let expect = XCTestExpectation(description: "Should initialize normally")
        
        self.database.initialize { result in
            switch result {
            case let .failure(error):
                print("Failed to initialize database: '\(error.localizedDescription)'")
            case .success(_):
                expect.fulfill()
            }
        }
        
        wait(for: [expect], timeout: 10)
    }
    
    func testDisplayOrderEntityPresent() {
        let expect = XCTestExpectation(description: "Should have displayOrder entity in storage")
        let _ = self.database.ratesOrder
        expect.fulfill()
    }
    
    func testAddNewRate() {
        let USD = CurrencyCode.USD
        let RUB = CurrencyCode.RUB
        let ratio = Decimal(string: "67.56")!
        
        guard let rateToAdd = CurrencyRate(USD, second: RUB, rate: ratio) else {
            XCTFail("Should create CurrencyRate normally")
            return
        }
        
        let expect = expectation(description: "Should add new rate normally")
        
        self.database.deleteRate(rateToAdd) { deleteResult in
            switch deleteResult {
            case let .failure(error):
                if error == .RateWasNotInStore {
                    fallthrough
                }
            case .success:
                self.database.createNewRate(rateToAdd) { addResult in
                    switch addResult {
                    case let .failure(error):
                        print("Failed to create rate: '\(error.localizedDescription)'")
                        
                    case let .success(receivedRate):
                        XCTAssert(receivedRate == rateToAdd, "Should receive the same currencyRate")
                        
                        DispatchQueue.main.async {
                            let request: NSFetchRequest<Rate> = Rate.fetchRequest()
                            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
                            
                            let firstCode = NSPredicate(format: "firstCode == '\(rateToAdd.first)'")
                            let secondCode = NSPredicate(format: "secondCode == '\(rateToAdd.second)'")
                            let ratio = NSPredicate(format: "ratio == \(rateToAdd.rate)")
                            
                            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [firstCode, secondCode, ratio])
                            
                            let context = self.database.persistentContainer.viewContext
                            let objects = try? context.fetch(request)
                            let rates = objects ?? []
                            if !rates.isEmpty {
                                expect.fulfill()
                            }
                        }
                    }
                }
            }
        }
        
        wait(for: [expect], timeout: 10)
    }
    
    func testRateDeletion() {
        let USD = CurrencyCode.USD
        let RUB = CurrencyCode.RUB
        let ratio = Decimal(string: "67.56")!
        
        guard let rateToDelete = CurrencyRate(USD, second: RUB, rate: ratio) else {
            XCTFail("Should create CurrencyRate normally")
            return
        }
        
        let expect = expectation(description: "Should delete rate normally")
        self.database.createNewRate(rateToDelete) { createResult in
            switch createResult {
            case let .failure(error):
                if error == .RateAlreadyExists {
                    fallthrough
                }
            case .success:
                self.database.deleteRate(rateToDelete) { deleteResult in
                    switch deleteResult {
                    case .failure:
                        break
                    case let .success(receivedRate):
                        XCTAssert(receivedRate == rateToDelete, "Should receive the same rate")
                        
                        DispatchQueue.main.async {
                            let request: NSFetchRequest<Rate> = Rate.fetchRequest()
                            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
                            
                            let firstCode = NSPredicate(format: "firstCode == '\(rateToDelete.first)'")
                            let secondCode = NSPredicate(format: "secondCode == '\(rateToDelete.second)'")
                            let ratio = NSPredicate(format: "ratio == \(rateToDelete.rate)")
                            
                            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [firstCode, secondCode, ratio])
                            
                            let context = self.database.persistentContainer.viewContext
                            do {
                                let objects = try context.fetch(request)
                                if objects.isEmpty {
                                    expect.fulfill()
                                }
                            }
                            catch {}
                        }
                    }
                }
            }
        }
        
        wait(for: [expect], timeout: 10)
    }
    
    func testSetNewRate() {
        let USD = CurrencyCode.USD
        let RUB = CurrencyCode.RUB
        let ratio = Decimal(string: "67.56")!
        
        guard let initialRate = CurrencyRate(USD, second: RUB, rate: ratio) else {
            XCTFail("Should create CurrencyRate normally")
            return
        }
        
        let expect = expectation(description: "Should delete rate normally")
        self.database.createNewRate(initialRate) { createResult in
            switch createResult {
            case let .failure(error):
                if error == .RateAlreadyExists {
                    fallthrough
                }
            case .success:
                let newRatio = Decimal(string: "32.60")!
                guard let newRate = CurrencyRate(initialRate.first, second: initialRate.second, rate: newRatio) else {
                    return
                }
                
                self.database.updateRateWith(newRate) { updateResult in
                    switch updateResult {
                    case .failure:
                        break
                    case let .success(receivedRate):
                        XCTAssert(receivedRate == newRate, "Should receive the same new rate")
                        
                        DispatchQueue.main.async {
                            let request: NSFetchRequest<Rate> = Rate.fetchRequest()
                            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
                            
                            let firstCode = NSPredicate(format: "firstCode == '\(newRate.first)'")
                            let secondCode = NSPredicate(format: "secondCode == '\(newRate.second)'")
                            let ratio = NSPredicate(format: "ratio == \(newRate.rate)")
                            
                            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [firstCode, secondCode, ratio])
                            
                            let context = self.database.persistentContainer.viewContext
                            do {
                                let objects = try context.fetch(request)
                                if !objects.isEmpty {
                                    expect.fulfill()
                                }
                            }
                            catch {}
                        }
                    }
                }
            }
        }
        
        wait(for: [expect], timeout: 10)
    }
    
    private let database = DatabaseImplementation()
}
