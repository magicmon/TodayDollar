//
//  RateCode.swift
//  TodayDollar
//
//  Created by magicmon on 2017. 7. 18..
//  Copyright © 2017년 magicmon. All rights reserved.
//

struct RateCode {
    let baseCode: String
    let symbolCode: String
    
    init(baseCode: String, symbolCode: String) {
        self.baseCode = baseCode
        self.symbolCode = symbolCode
    }
}

extension RateCode: Equatable {
    static func == (lhs: RateCode, rhs: RateCode) -> Bool {
        return lhs.baseCode == rhs.baseCode &&
            lhs.symbolCode == rhs.symbolCode
    }
}
