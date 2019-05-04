//
//  DatabaseObserver.swift
//  DatabaseService
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import CurrencyRate

public protocol DatabaseObserver: class {
    
    func database(_ database: DatabaseService, didCreateRate rate: CurrencyRate)
    func database(_ database: DatabaseService, didChangeRateTo newRate: CurrencyRate)
    func database(_ database: DatabaseService, didDeleteRate rate: CurrencyRate)
}
