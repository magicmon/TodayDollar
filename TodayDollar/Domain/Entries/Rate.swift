//
//  Rate.swift
//  TodayDollar
//
//  Created by magicmon on 2017. 7. 17..
//  Copyright © 2017년 magicmon. All rights reserved.
//

import Foundation

struct Rate {
    let currencyCode: String
    let basicRate: Double
    
    init(currencyCode: String, basicRate: Double) {
        self.currencyCode = currencyCode
        self.basicRate = basicRate
    }
}

extension Rate: Equatable {
    static func == (lhs: Rate, rhs: Rate) -> Bool {
        return lhs.currencyCode == rhs.currencyCode &&
                lhs.basicRate == rhs.basicRate
    }
}


