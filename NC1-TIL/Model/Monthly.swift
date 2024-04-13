//
//  MonthlyData.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/13/24.
//

import Foundation

struct Monthly: Hashable {
    var date: Date
    var days: Int
    var links: [Link]
}
