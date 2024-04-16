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
    var isLoading: Bool = false
    var totalContributions: Int = 0
    var currentMonthly: Monthly?
    
    /// 모든 LInk 데이터를 가져옴
    func fetchAllLink() {
        isLoading = true
        
        CloudService.shared.fetchLinks { result in
            switch result {
            case .success(let links):
                self.createMonthlys(links)
                self.totalContributions = links.count
            case .failure(let error):
                print(error)
            }
            
            self.isLoading = false
        }
    }
    
    func deleteLink(_ link: URLLink) {
        isLoading = true
        
        CloudService.shared.deleteLink(link.recordID) { result in
            switch result {
            case .success(let success):
                self.deleteLinkFromMonthly(link)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            
            self.isLoading = false
        }
    }
    
    /// Link 데이터로 Monthlys 데이터를 만듦
    /// - Parameter links: [Link] 데이터
    func createMonthlys(_ links: [URLLink]) {
        let calendar = Calendar.current
        
        var currentDate = links[0].date.convertYearAndMonthDate()
        let endDate = links[links.count-1].date.convertYearAndMonthDate()
        
        let dic = groupedLink(links)
        var newMonthlys: [Monthly] = []
        
        while currentDate <= endDate {
            newMonthlys.append(Monthly(date: currentDate, days: currentDate.daysInMonth(), links: dic[currentDate] ?? []))
            
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
        }
        monthlys = newMonthlys
    }
    
    /// Link 데이터를 Date별로 그룹화
    /// - Parameter links: [Link] 데이터
    /// - Returns: [Date: [Link]]
    func groupedLink(_ links: [URLLink]) -> [Date: [URLLink]] {
        var dic: [Date: [URLLink]] = [:]
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
    
    private func deleteLinkFromMonthly(_ link: URLLink) {
//        guard let monthly = currentMonthly,
//              let monthlyIndex = monthlys.firstIndex(where: { $0.date == monthly.date }),
//              let linkIndex = monthlys[monthlyIndex].links.firstIndex(where: { $0.date == link.date }) 
//        else { print("return"); return }
//        
//        
//        
//        for mIdx in (monthlyIndex + 1)..<monthlys.count {
//            for lIdx in monthlys[mIdx].links.indices {
//                monthlys[mIdx].links[lIdx].id -= 1
//            }
//        }
//        
//        monthlys[monthlyIndex].links.remove(at: linkIndex)
        
        var monthlyIdx = 0
        var linkIdx = 0
        
        for i in monthlys.indices {
            for j in monthlys[i].links.indices {
                if monthlys[i].links[j].id == link.id {
                    monthlyIdx = i
                    linkIdx = j
                }
            }
        }
        
        for i in (monthlyIdx + 1)..<monthlys.count {
            for j in monthlys[i].links.indices {
                monthlys[i].links[j].id -= 1
            }
        }
        
        monthlys[monthlyIdx].links.remove(at: linkIdx)
    }
    
    func scrollToCurrentDate() {
        currentMonthly = monthlys.last
    }
}
