//
//  HomeViewModel.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/13/24.
//

import Foundation

@Observable
class HomeViewModel {
    var tilData: [TILData] = []
    var isLoading: Bool = true
    
    func fetchAllLink() {
        CloudService.shared.fetchLinks { result in
            switch result {
            case .success(let links):
                self.convertToTILData(links)
                self.isLoading = false
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func convertToTILData(_ links: [Link]) {
        let calendar = Calendar.current
        
        var currentDate = links[0].date.convertYearAndMonthDate()
        let endDate = links[links.count-1].date.convertYearAndMonthDate()
        
        let dic = groupedLink(links)
        
        while currentDate <= endDate {
            tilData.append(TILData(date: currentDate, days: currentDate.daysInMonth(), links: dic[currentDate] ?? []))
            
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
        }
    }
    
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
}
