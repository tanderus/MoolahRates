//
//  RatesIoDecoder.swift
//  BackendService
//
//  Created by Pavel Krasnobrovkin on 04/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import CurrencyCode
import CurrencyRate

class RatesIoDecoder {
    
    func ratesFromData(_ data: Data, using pairs: Set<CurrencyPair>) -> Set<CurrencyRate>? {
        let decoder = JSONDecoder()
        do {
            let json = try decoder.decode(RatesIoResponse.self, from: data)
            guard let baseCurrencyReceived = CurrencyCode(rawValue: json.base) else {
                return nil
            }
            
            let receivedRates = json.rates.compactMap {
                CurrencyRate(baseCurrencyReceived.rawValue, secondCode: $0.key, rate: $0.value)
            }
            var received = [CurrencyCode: CurrencyRate]()
            receivedRates.forEach { received[$0.second] = $0 }
            
            var result = Set<CurrencyRate>()
            pairs.forEach { pair in
                
                if pair.second == baseCurrencyReceived {
                    
                    if let reversedRate = received[pair.first]
                        , !reversedRate.rate.isZero
                        , let rate = CurrencyRate(pair, rate: 1 / reversedRate.rate)
                    {
                        result.insert(rate)
                    }
                    
                    return
                }
                
                guard let baseToTargetRate = received[pair.second] else {
                    return
                }
                
                if pair.first == baseCurrencyReceived {
                    result.insert(baseToTargetRate)
                    return
                }
                
                
                guard !baseToTargetRate.rate.isZero else {
                    return
                }
                
                guard let baseToFirstRate = received[pair.first] else {
                    return
                }
                
                guard !baseToFirstRate.rate.isZero else {
                    return
                }
                
                let rate = (1 / baseToFirstRate.rate) / (1 / baseToTargetRate.rate)
                guard let currencyRate = CurrencyRate(pair, rate: rate) else {
                    return
                }
                
                result.insert(currencyRate)
            }
            
            return result
        }
        catch {
            return nil
        }
    }
}
