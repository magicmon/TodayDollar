//
//  ExchangeRate.swift
//  TodayDollar
//
//  Created by magicmon on 2017. 7. 17..
//  Copyright © 2017년 magicmon. All rights reserved.
//

import Foundation


struct ExchangeRate {
    let base: String
    let date: Date
    let rates: [Rate]
    
}

extension ExchangeRate {
    
    var maxRates: Double {
        return self.rates.map { $0.basicRate }.max() ?? 0.0
    }
    
    var minRates: Double {
        return self.rates.map { $0.basicRate }.min() ?? 0.0
    }
}

extension ExchangeRate: Equatable {
    static func == (lhs: ExchangeRate, rhs: ExchangeRate) -> Bool {
        return lhs.base == rhs.base &&
                lhs.date == rhs.date &&
                lhs.rates == rhs.rates
    }
}
