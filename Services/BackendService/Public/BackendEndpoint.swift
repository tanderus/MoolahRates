//
//  BackendEndpoint.swift
//  BackendService
//
//  Created by Pavel Krasnobrovkin on 04/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import Foundation

public enum BackendEndpoint {
    
    case RATES_IO
}

internal extension BackendEndpoint {
    
    var url: URL {
        switch self {
        case .RATES_IO:
            return URL(string: "https://api.ratesapi.io/api/latest")!
        }
    }
}
