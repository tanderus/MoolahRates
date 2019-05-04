//
//  RatesIoResponse.swift
//  BackendService
//
//  Created by Pavel Krasnobrovkin on 04/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import Foundation

struct RatesIoResponse: Decodable {
    
    let base: String
    let rates: [String: Decimal]
    
}
