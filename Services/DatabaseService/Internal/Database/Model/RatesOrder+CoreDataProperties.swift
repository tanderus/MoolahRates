//
//  RatesOrder+CoreDataProperties.swift
//  DatabaseService
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//
//

import Foundation
import CoreData


extension RatesOrder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RatesOrder> {
        return NSFetchRequest<RatesOrder>(entityName: "RatesOrder")
    }

    @NSManaged public var sortedRates: NSOrderedSet

}

// MARK: Generated accessors for sortedRates
extension RatesOrder {

    @objc(insertObject:inSortedRatesAtIndex:)
    @NSManaged public func insertIntoSortedRates(_ value: Rate, at idx: Int)

    @objc(removeObjectFromSortedRatesAtIndex:)
    @NSManaged public func removeFromSortedRates(at idx: Int)

    @objc(insertSortedRates:atIndexes:)
    @NSManaged public func insertIntoSortedRates(_ values: [Rate], at indexes: NSIndexSet)

    @objc(removeSortedRatesAtIndexes:)
    @NSManaged public func removeFromSortedRates(at indexes: NSIndexSet)

    @objc(replaceObjectInSortedRatesAtIndex:withObject:)
    @NSManaged public func replaceSortedRates(at idx: Int, with value: Rate)

    @objc(replaceSortedRatesAtIndexes:withSortedRates:)
    @NSManaged public func replaceSortedRates(at indexes: NSIndexSet, with values: [Rate])

    @objc(addSortedRatesObject:)
    @NSManaged public func addToSortedRates(_ value: Rate)

    @objc(removeSortedRatesObject:)
    @NSManaged public func removeFromSortedRates(_ value: Rate)

    @objc(addSortedRates:)
    @NSManaged public func addToSortedRates(_ values: NSOrderedSet)

    @objc(removeSortedRates:)
    @NSManaged public func removeFromSortedRates(_ values: NSOrderedSet)

}
