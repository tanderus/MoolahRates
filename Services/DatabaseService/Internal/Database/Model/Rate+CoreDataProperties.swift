//
//  Rate+CoreDataProperties.swift
//  DatabaseService
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//
//

import Foundation
import CoreData


extension Rate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rate> {
        return NSFetchRequest<Rate>(entityName: "Rate")
    }

    @NSManaged public var firstCode: String
    @NSManaged public var ratio: NSDecimalNumber
    @NSManaged public var secondCode: String
    @NSManaged public var createdAt: NSDate
    
    @NSManaged public var order: RatesOrder
}
