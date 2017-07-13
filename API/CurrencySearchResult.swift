//
//  CurrencySearchResult.swift
//  TodayDollar
//
//  Created by magicmon on 2017. 7. 13..
//  Copyright © 2017년 magicmon. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CurrencySearchResult {
    
    let base: String
    let date: Date
    let rates: [String: Any]
    
    static func parseJSON(_ jsonObject: Any) throws -> CurrencySearchResult {
        let json = JSON(jsonObject)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: json["date"].stringValue)
        
        return CurrencySearchResult(base: json["base"].stringValue, date: date ?? Date(), rates: json["rates"].dictionaryObject ?? [:])
    }
}
