//
//  ExchangeRatesNetwork.swift
//  TodayDollar
//
//  Created by magicmon on 2017. 7. 17..
//  Copyright © 2017년 magicmon. All rights reserved.
//

import RxSwift

final class ExchangeRatesNetwork {
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    func specifiecExchangeRates(from baseRate: String? = nil, to symbols: [String]? = nil) -> Observable<ExchangeRate> {
        return network.getExchangeRates(from: baseRate, to: symbols)
    }
    
    func historicalRates(from baseRate: String? = "USD", to symbols: [String], peroid: Int = 7) -> Observable<[ExchangeRate]> {
        return network.getHistoricalRates(from: baseRate, to: symbols, peroid: peroid)
    }
}
