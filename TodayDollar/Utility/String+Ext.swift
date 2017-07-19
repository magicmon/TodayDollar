//
//  String+Ext.swift
//  TodayDollar
//
//  Created by magicmon on 2017. 7. 18..
//  Copyright © 2017년 magicmon. All rights reserved.
//

import Foundation

extension String {
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
