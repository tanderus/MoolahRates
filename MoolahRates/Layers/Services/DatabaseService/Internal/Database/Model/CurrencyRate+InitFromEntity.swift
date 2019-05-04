//
//  CurrencyRate+InitFromEntity.swift
//  DatabaseService
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import CurrencyRate

extension CurrencyRate {
    
    init?(rate: Rate) {
        self.init(rate.firstCode, secondCode: rate.secondCode, rate: rate.ratio as Decimal)
    }
}
