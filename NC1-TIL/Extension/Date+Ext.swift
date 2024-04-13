//
//  Date+Ext.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/13/24.
//

import Foundation

extension Date {
    func convertUTCTimeFromNow() -> Self {
        let calendar = Calendar.current
        var components = DateComponents()
        
        components.year = calendar.component(.year, from: self)
        components.month = calendar.component(.month, from: self)
        components.day = calendar.component(.day, from: self)
        components.hour = 9

        return calendar.date(from: components)!
    }
}
