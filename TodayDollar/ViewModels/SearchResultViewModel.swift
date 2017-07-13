//
//  SearchResultViewModel.swift
//  TodayDollar
//
//  Created by magicmon on 2017. 7. 13..
//  Copyright © 2017년 magicmon. All rights reserved.
//

import Foundation
class SearchResultViewModel {
    let searchResult: CurrencySearchResult
    
    var dateStr: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: searchResult.date)
    }
    
    init(searchResult: CurrencySearchResult) {
        
        self.searchResult = searchResult
        
        print("model: \(searchResult.base)")
        print("rates: \(searchResult.rates)")
    }
    
    
    func getRates(from currency: String) -> String? {
        guard let rates = searchResult.rates[currency] as? Double else {
            return nil
        }
        
        return "\(rates)"
    }
}
