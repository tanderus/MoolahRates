//
//  DatabaseImplementation.swift
//  DatabaseService
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import CurrencyRate
import CurrencyCode

import CoreData

final class DatabaseImplementation: DatabaseService {
    
    init() {
        let directoryURL = FileManager.default.storeDirectoryUrl!
        let storeURL = directoryURL.appendingPathComponent("Database.sqlite")
        
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        storeDescription.shouldMigrateStoreAutomatically = true
        storeDescription.shouldInferMappingModelAutomatically = true
        storeDescription.type = NSSQLiteStoreType
        
        let bundle = Bundle(for: DatabaseImplementation.self)
        let modelUrl = bundle.url(forResource: "Database", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelUrl)!
        
        self.persistentContainer = NSPersistentContainer(name: "Database", managedObjectModel: model)
        self.persistentContainer.persistentStoreDescriptions = [storeDescription]
    }
    
    func addObserver(_ observer: DatabaseObserver) {
        if self.observers.contains(where: { $0 === observer }) {
            return
        }
        
        _observerReferences.add(observer)
    }
    
    func removeObserver(_ observer: DatabaseObserver) {
        _observerReferences.remove(observer)
    }
    
    func initialize(completion: @escaping (Result<[CurrencyRate], DatabaseError>) -> Void) {
        self.privateInitialize(completion: completion)
    }
    
    var latestRatesSorted: [CurrencyRate] {
        return self.privateLatestRatesSorted
    }
    
    func createNewRate(_ rate: CurrencyRate, completion: @escaping (Result<CurrencyRate, RateAddingError>) -> Void) {
        self.privateCreateNewRate(rate, completion: completion)
    }
    
    func updateRateWith(
        _ newRate: CurrencyRate
        , completion: @escaping (Result<CurrencyRate, RateUpdateError>) -> Void
        ) {
        self.privateUpdateRateWith(newRate, completion: completion)
    }
    
    func deleteRate(
        _ rate: CurrencyRate
        , completion: @escaping (Result<CurrencyRate, RateDeletionError>) -> Void
        ) {
        self.privateDeleteRate(rate, completion: completion)
    }
    
    // MARK: -
    // MARK: Properties
    internal let persistentContainer: NSPersistentContainer
    
    internal let _observerReferences = NSHashTable<AnyObject>.weakObjects()
    internal var observers: [DatabaseObserver] {
        return _observerReferences
            .allObjects
            .compactMap { $0 as? DatabaseObserver }
    }
}
