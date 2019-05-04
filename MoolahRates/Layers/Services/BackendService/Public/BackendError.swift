//
//  BackendError.swift
//  BackendService
//
//  Created by Pavel Krasnobrovkin on 04/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import Foundation

public enum BackendError: Error {
    
    case WrongArguments
    
    case TimedOut
    case ServiceNotAvailable
    case WrongResponseReceived
}
