//
//  HomeViewModel.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/13/24.
//

import Foundation

@Observable
class HomeViewModel {
    var monthlys: [Monthly] = []
    var isLoading: Bool = true
    var currentIndex: Int?
    var totalContributions: Int = 0
    
    
    /// 모든 LInk 데이터를 가져옴
    func fetchAllLink() {
        CloudService.shared.fetchLinks { result in
            switch result {
            case .success(let links):
                self.createMonthlys(links)
                self.totalContributions = links.count
                self.isLoading = false
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// Link 데이터로 Monthlys 데이터를 만듦
    /// - Parameter links: [Link] 데이터
    func createMonthlys(_ links: [Link]) {
        let calendar = Calendar.current
        
        var currentDate = links[0].date.convertYearAndMonthDate()
        let endDate = links[links.count-1].date.convertYearAndMonthDate()
        
        let dic = groupedLink(links)
        
        while currentDate <= endDate {
            monthlys.append(Monthly(date: currentDate, days: currentDate.daysInMonth(), links: dic[currentDate] ?? []))
            
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
        }
    }
    
    /// Link 데이터를 Date별로 그룹화
    /// - Parameter links: [Link] 데이터
    /// - Returns: [Date: [Link]]
    func groupedLink(_ links: [Link]) -> [Date: [Link]] {
        var dic: [Date: [Link]] = [:]
        for link in links {
            let date = link.date.convertYearAndMonthDate()
            if dic[date] == nil {
                dic[date] = [link]
            } else {
                dic[date]?.append(link)
            }
        }
        return dic
    }
    
    func scrollToCurrentDate() {
        currentIndex = monthlys.count - 1
    }
}