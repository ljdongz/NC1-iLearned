//
//  HomeViewModel.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/13/24.
//

import Foundation
import AppKit

@Observable
class HomeViewModel {
    
    private(set) var monthlys: [Monthly] = []
    private(set) var totalContributions: Int = 0
    private(set) var isLoading: Bool = false
    private(set) var terminalText: String = ""
}


// MARK: - HomeView 관련 로직
extension HomeViewModel {
    /// 터미널 입력 필드 상태를 변경
    /// - Parameter state: 터미널 상태 종류
    func setTerminalState(_ state: TerminalState) {
        switch state {
        case .load:
            self.updateTerminalField(text: "Loading...", isLoading: true)
            Task { await fetchAllLinks() }
        case .create(let title, let url):
            self.updateTerminalField(text: "Creating...", isLoading: true)
            Task { await saveLink(title: title, url: url) }
        case .read(let id):
            self.updateTerminalField(text: "Input Command", isLoading: false)
            self.getLinkFromLinkID(id)
        case .delete(let id):
            self.updateTerminalField(text: "Deleting...", isLoading: true)
            self.deleteLink(id)
        case .help, .done:
            self.updateTerminalField(text: "Input Command", isLoading: false)
        case .error(let message), .invalid(message: let message):
            self.updateTerminalField(text: message, isLoading: false)
        }
    }
    
    /// Terminal Input Field 상태를 변경
    /// - Parameters:
    ///   - text: TextField에 보여줄 text
    ///   - isLoading: ProgressView를 나타낼지 여부
    private func updateTerminalField(text: String, isLoading: Bool) {
        self.terminalText = text
        self.isLoading = isLoading
    }
    
    /// URL 주소로 이동
    /// - Parameter id: Link ID
    private func getLinkFromLinkID(_ id: Int) {
        for monthly in monthlys {
            for link in monthly.links {
                if link.id == id {
                    let isValid = openURL(urlString: link.url)
                    let text = isValid ? "Input Command" : "유효하지 않은 URL"
                    self.updateTerminalField(text: text, isLoading: false)
                }
            }
        }
    }
    
    /// URL 주소로 브라우저를 엶
    /// - Parameter urlString: url 주소
    /// - Returns: URL 주소가 유효한지에 대한 여부
    private func openURL(urlString: String) -> Bool {
        guard let url = URL(string: urlString) else {
            return false
        }
        
        return NSWorkspace.shared.open(url)
    }
}

// MARK: - CloudSerivce 관련 로직
extension HomeViewModel {
    /// CloudService를 통해 모든 Link 데이터를 가져옴
    private func fetchAllLinks() async {
        CloudService.shared.fetchLinks { result in
            switch result {
            case .success(let links):
                self.createMonthlys(links)
                self.totalContributions = links.count
                self.updateTerminalField(text: "Input Command", isLoading: false)
            case .failure(let error):
                self.updateTerminalField(text: error.localizedDescription, isLoading: false)
            }
        }
    }
    
    /// CloudService를 통해 새로운 Link 데이터 생성
    /// - Parameters:
    ///   - title: 제목
    ///   - url: URL 주소
    private func saveLink(title: String, url: String) async {
        CloudService.shared.saveLink(title: title, url: url) { result in
            switch result {
            case .success:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    Task { await self.fetchAllLinks() }
                }
            case .failure(let failure):
                self.updateTerminalField(text: failure.localizedDescription, isLoading: false)
            }
        }
    }
    
    /// CloudService를 통해 Link 데이터 삭제
    /// - Parameter id: Link ID
    private func deleteLink(_ id: Int) {
        for monthly in monthlys {
            for link in monthly.links {
                if link.id == id {
                    CloudService.shared.deleteLink(link.recordID) { result in
                        switch result {
                        case .success:
                            Task { await self.fetchAllLinks() }
                        case .failure(let failure):
                            self.updateTerminalField(text: failure.localizedDescription, isLoading: false)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Date 관련 로직
extension HomeViewModel {
    
    /// Link 데이터로 Monthlys 데이터를 만듦
    /// - Parameter links: [Link] 데이터
    private func createMonthlys(_ links: [URLLink]) {
        
        let dic = groupedLink(links)
        let sortedDic = dic.sorted { $0.key < $1.key }
        
        var newMonthlys: [Monthly] = []
        
        for (key, value) in sortedDic {
            let days = self.assignLinkToDays(days: key.daysInMonth(), links: value)
            newMonthlys.append(Monthly(date: key, days: days, links: value))
        }
        
        monthlys = newMonthlys
    }
    
    /// Link 데이터를 Date별로 그룹화
    /// - Parameter links: [Link] 데이터
    /// - Returns: [Date: [Link]]
    private func groupedLink(_ links: [URLLink]) -> [Date: [URLLink]] {
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
    
    /// 일수만큼 배열을 만들고 각 일수마다 Link가 얼마나 등록됐는지 카운트
    /// - Parameters:
    ///   - days: 총 일수
    ///   - links: [URLLink] 데이터
    /// - Returns: 일수
    private func assignLinkToDays(days: Int, links: [URLLink]) -> [Int] {
        var array = Array(repeating: 0, count: days)
        
        for link in links {
            array[link.date.currentDay()-1] += 1
        }
        
        return array
    }
}
