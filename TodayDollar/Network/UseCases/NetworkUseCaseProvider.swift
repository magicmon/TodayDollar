//
//  NetworkUseCaseProvider.swift
//  TodayDollar
//
//  Created by magicmon on 2017. 7. 17..
//  Copyright © 2017년 magicmon. All rights reserved.
//

class NetworkUseCaseProvider: UseCaseProvider {
    private let networkProvider: NetworkProvider
    
    init() {
        networkProvider = NetworkProvider()
    }
    
    func makeExchangeRatesUseCase() -> AllExchangeRatesUseCase {
        return NetworkExchangeRatesUseCase(network: networkProvider.makeExchangeRatesNetwork())
    }
}
