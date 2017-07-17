//
//  NetworkProvider.swift
//  TodayDollar
//
//  Created by magicmon on 2017. 7. 17..
//  Copyright © 2017년 magicmon. All rights reserved.
//

import Foundation
import RxSwift


final class NetworkProvider {
    private let apiEndpoint: String
    
    init() {
        apiEndpoint = "https://api.fixer.io"
    }
    
    func makeExchangeRatesNetwork() -> ExchangeRatesNetwork {
        let network = Network(apiEndpoint)
        return ExchangeRatesNetwork(network: network)
    }
}
