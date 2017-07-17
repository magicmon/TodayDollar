//
//  ExchangeRates+Mapping.swift
//  TodayDollar
//
//  Created by magicmon on 2017. 7. 17..
//  Copyright © 2017년 magicmon. All rights reserved.
//

import SwiftyJSON

extension ExchangeRate {
    
    static func parseJSON(_ jsonObject: Any) throws -> ExchangeRate {
        let json = JSON(jsonObject)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: json["date"].stringValue)
        
        
        guard let ratesDic = json["rates"].dictionaryObject else {
            throw apiError("parsing error")
        }
        
        var rates = [Rate]()
        
        rates = ratesDic.map { (key: String, value: Any) -> Rate in
            return Rate(currencyCode: key, basicRate: ratesDic[key] as? Double ?? 0.0)
        }
        
        return ExchangeRate(base: json["base"].stringValue, date: date ?? Date(), rates: rates)
    }
    
    static func parseJSONs(_ jsonObject: Any) throws -> [ExchangeRate] {
        guard  let jsonObject = jsonObject as? [(HTTPURLResponse, Any)]  else {
            throw apiError("parsing error")
        }
        
        var results = [ExchangeRate]()
        
        for json in jsonObject {
            let parsed = try ExchangeRate.parseJSON(json.1)
            results.append(parsed)
        }
        
        return results
    }
}
