//
//  Network.swift
//  TodayDollar
//
//  Created by magicmon on 2017. 7. 17..
//  Copyright © 2017년 magicmon. All rights reserved.
//

import UIKit
import Foundation
import RxAlamofire
import RxSwift


func apiError(_ error: String, location: String = "\(#file):\(#line)") -> NSError {
    return NSError(domain: "TodayDollar", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(location): \(error)"])
}

final class Network {
    private let endPoint: String
    
    init(_ endPoint: String) {
        self.endPoint = endPoint
    }
    
    func getExchangeRates(from baseRate: String? = nil, to symbols: [String]? = nil) -> Observable<ExchangeRate> {
        let absolutePath = "\(endPoint)/latest\(addParameters(from: baseRate, to: symbols))"
        
        return RxAlamofire.requestJSON(.get, absolutePath)
            .debug()
            .map { response, json in
                return try ExchangeRate.parseJSON(json)
        }
    }
    
    // https://api.fixer.io/2017-07-12?base=USD&symbols=KRW
    func getHistoricalRates(from baseRate: String? = nil, to symbols: [String]? = nil, peroid: Int? = nil) -> Observable<[ExchangeRate]> {
        // max 7 days
        var peroid = peroid ?? 7
        if peroid > 7 { peroid = 7 }
        if peroid < 0 { peroid = 1 }
        
        var requests: [Observable<(HTTPURLResponse, Any)>] = []
        
        for days in ( 1...peroid).reversed() {
            
            let absolutePath = "\(endPoint)/\(Date().daysAgo(value: days).stringValue)\(addParameters(from: baseRate, to: symbols))"
            let url = URL(string: absolutePath)!
            
            let request = RxAlamofire.requestJSON(.get, url)
            
            requests.append(request)
        }

        return Observable.combineLatest(requests)
            .debug()
            .map { response in
                return try ExchangeRate.parseJSONs(response)
        }
    }
}

extension Network {
    func addParameters(from baseRate: String? = "USD", to symbols: [String]?) -> String {
        var parameters = "?base=\(baseRate?.URLEscaped ?? "USD")"
        
        if let symbols = symbols {
            parameters = "\(parameters)&symbols=\(symbols.joined(separator: ",").URLEscaped)"
        }
        
        return parameters
    }
}

extension String {
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}

extension Date {
    func daysAgo(value: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -value, to: self)!
    }
    
    var stringValue: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: self)
    }
}
