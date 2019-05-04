//
//  BackendService.swift
//  BackendService
//
//  Created by Pavel Krasnobrovkin on 04/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import CurrencyCode
import CurrencyRate

public protocol BackendService {
    
    func downloadLatestRatesForPairs(
        currencyPairs: Set<CurrencyPair>
        , endpoint: BackendEndpoint
        , completion: @escaping (Result<Set<CurrencyRate>, BackendError>) -> Void
    )
}

public func CreateNewBackendInstance() -> BackendService {
    return BackendImplementation()
}
