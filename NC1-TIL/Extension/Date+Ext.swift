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
    
    func convertUTCTimeFromMonth() -> Self {
        let calendar = Calendar.current
        var components = DateComponents()
        
        components.year = calendar.component(.year, from: self)
        components.month = calendar.component(.month, from: self)
        components.hour = 9

        return calendar.date(from: components)!
    }
    
    func daysInMonth() -> Int {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = calendar.component(.year, from: self)
        dateComponents.month = calendar.component(.month, from: self)
        
        guard let date = calendar.date(from: dateComponents) else { return 0 }
        
        // 해당 월의 마지막 날을 계산하기 위해 다음 달의 첫째 날을 구하고 하루를 빼줍니다.
        guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: date) else { return 0 }
        guard let lastDayOfMonth = calendar.date(byAdding: .day, value: -1, to: nextMonth) else { return 0 }
        
        // 마지막 날의 'day' 컴포넌트를 반환
        let day = calendar.component(.day, from: lastDayOfMonth)
        return day
    }
    
    func convertYearAndMonthDate() -> Date {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = calendar.component(.year, from: self)
        dateComponents.month = calendar.component(.month, from: self)
        dateComponents.hour = 9
        
        guard let date = calendar.date(from: dateComponents) else {
            return Date()
        }
        
        return date
    }
}
