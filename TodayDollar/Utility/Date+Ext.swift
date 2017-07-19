//
//  Date+Ext.swift
//  TodayDollar
//
//  Created by magicmon on 2017. 7. 18..
//  Copyright © 2017년 magicmon. All rights reserved.
//

import Foundation

extension Date {
    func daysAgo(value: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -value, to: self)!
    }
    
    var stringValue: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: self)
    }
    
    var dayNumberOfWeek: Int? {
        return Calendar.current.component(.weekday, from: self)
    }
}
