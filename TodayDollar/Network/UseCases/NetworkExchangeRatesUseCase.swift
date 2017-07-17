//
//  AllExchangeRatesUseCase.swift
//  TodayDollar
//
//  Created by magicmon on 2017. 7. 17..
//  Copyright © 2017년 magicmon. All rights reserved.
//

import Foundation
import RxSwift

class NetworkExchangeRatesUseCase: AllExchangeRatesUseCase {
    private let network: ExchangeRatesNetwork
    
    init(network: ExchangeRatesNetwork) {
        self.network = network
    }
    
    func exchangeRates() -> Observable<ExchangeRate> {
        return network.specifiecExchangeRates()
    }
    
    func exchangeRates(from baseRate: String?) -> Observable<ExchangeRate> {
        return network.specifiecExchangeRates(from: baseRate)
    }
    
    func exchangeRates(from baseRate: String?, to symbols: [String]) -> Observable<ExchangeRate> {
        return network.specifiecExchangeRates(from: baseRate, to: symbols)
    }
    
}
