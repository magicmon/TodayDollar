//
//  CurrencySearchAPI.swift
//  TodayDollar
//
//  Created by magicmon on 2017. 7. 13..
//  Copyright © 2017년 magicmon. All rights reserved.
//
import RxSwift
import RxAlamofire


func apiError(_ error: String, location: String = "\(#file):\(#line)") -> NSError {
    return NSError(domain: "TodayDollar", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(location): \(error)"])
}

class CurrencySearchAPI {
    
    static let sharedAPI = CurrencySearchAPI()
//    
//    private func lastestForeignRates(by baseRate: String? = nil) {
//        
//    }
//    
    let bag = DisposeBag()
    
    // https://api.fixer.io/latest?symbols=KRW&base=USD
    func specifiecExchangeRates(by symbols: [String], baseRate: String? = nil) -> Observable<CurrencySearchResult> {
        let url = URL(string: "http://api.fixer.io/latest?symbols=\(symbols.joined(separator: ",").URLEscaped)&base=\(baseRate?.URLEscaped ?? "")")!
        
        return RxAlamofire.requestJSON(.get, url)
            .debug()
            .map { response, json in
                return try CurrencySearchResult.parseJSON(json)
            }
    }
}

extension String {
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
