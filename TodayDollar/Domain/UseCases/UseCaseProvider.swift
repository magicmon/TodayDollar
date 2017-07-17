//
//  UseCaseProvider.swift
//  TodayDollar
//
//  Created by magicmon on 2017. 7. 17..
//  Copyright © 2017년 magicmon. All rights reserved.
//

import Foundation

protocol UseCaseProvider {
    func makeExchangeRatesUseCase() -> AllExchangeRatesUseCase
}
