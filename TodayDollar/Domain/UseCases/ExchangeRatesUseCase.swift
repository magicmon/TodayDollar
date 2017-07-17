//
//  ExchangeRatesUseCase.swift
//  TodayDollar
//
//  Created by magicmon on 2017. 7. 17..
//  Copyright © 2017년 magicmon. All rights reserved.
//

import Foundation
import RxSwift

protocol AllExchangeRatesUseCase {
    func exchangeRates() -> Observable<ExchangeRate>
    func exchangeRates(from baseRate: String?) -> Observable<ExchangeRate>
    func exchangeRates(from baseRate: String?, to symbols: [String]) -> Observable<ExchangeRate>
}
