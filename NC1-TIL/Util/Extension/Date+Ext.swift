//
//  Date+Ext.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/13/24.
//

import Foundation

extension Date {
    
    /// 현재 달에 총 며칠이 있는지를 계산
    /// - Returns: 총 일수
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
    
    
    func convertYearAndMonthDate() -> Self {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = calendar.component(.year, from: self)
        dateComponents.month = calendar.component(.month, from: self)
        dateComponents.hour = 9
        
        return calendar.date(from: dateComponents)!
    }
    
    func currentYear() -> Int {
        return Calendar.current.component(.year, from: self)
    }
    
    func currentMonth() -> Int {
        return Calendar.current.component(.month, from: self)
    }
    
    func currentDay() -> Int {
        return Calendar.current.component(.day, from: self)
    }
    
    func convertToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일 HH:mm"
        return formatter.string(from: self)
    }
}
