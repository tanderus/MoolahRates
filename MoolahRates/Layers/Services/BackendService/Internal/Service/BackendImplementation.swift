//
//  BackendImplementation.swift
//  BackendService
//
//  Created by Pavel Krasnobrovkin on 04/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import CurrencyCode
import CurrencyRate

final class BackendImplementation: BackendService {
    
    init() {
        
    }
    
    
    func downloadLatestRatesForPairs(
        currencyPairs: Set<RateCurrencyPair>
        , endpoint: BackendEndpoint
        , completion: @escaping (Result<Set<CurrencyRate>, BackendError>) -> Void
        ) {
        
        if currencyPairs.isEmpty {
            DispatchQueue.main.async {
                completion(.failure(.WrongArguments))
            }
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: endpoint.url) { (data, response, error) in
            if let error = error as NSError? {
                if error.code == NSURLErrorTimedOut {
                    DispatchQueue.main.async {
                        completion(.failure(.TimedOut))
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completion(.failure(.ServiceNotAvailable))
                    }
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.WrongResponseReceived))
                }
                return
            }
            
            guard let rates = RatesIoDecoder().ratesFromData(data, using: currencyPairs) else {
                
                DispatchQueue.main.async {
                    completion(.failure(.WrongResponseReceived))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(rates))
            }
        }
        
        task.resume()
    }
}
