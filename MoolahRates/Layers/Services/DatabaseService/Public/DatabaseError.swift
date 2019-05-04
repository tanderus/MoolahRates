//
//  DatabaseError.swift
//  DatabaseService
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import Foundation

public enum DatabaseError: Error {
    
    case InternalError
    case NotEnoughDiskSpace(requiredDiskSpaceBytes: Int)
}

public enum RateAddingError: Error {
    
    case RateAlreadyExists
    case FailedToSave
}

public enum RateUpdateError: Error {
    
    case RateNotInStore
    case FailedToSave
}

public enum RateDeletionError: Error {
    
    case RateWasNotInStore
    case FailedToSave
}
