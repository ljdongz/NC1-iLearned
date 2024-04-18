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
    
    var monthlys: [Monthly] = [] {
        didSet {
            print(monthlys)
        }
    }
    
    var totalContributions: Int = 0
    
    var isLoading: Bool = false
    var terminalText: String = ""
    
    func setTerminalState(_ state: TerminalState) {
        
        switch state {
        case .load:
            isLoading = true
            terminalText = "Loading..."
            CloudService.shared.fetchLinks { result in
                switch result {
                case .success(let links):
                    self.createMonthlys(links)
                    self.totalContributions = links.count
                    self.isLoading = false
                    self.terminalText = ""
                case .failure(let error):
                    self.isLoading = false
                    self.terminalText = error.localizedDescription
                }
            }
        case .create(let title, let url):
            isLoading = true
            terminalText = "Creating..."
            CloudService.shared.saveLink(title: title, url: url) { result in
                
                switch result {
                case .success:
                    CloudService.shared.fetchLinks { result in
                        switch result {
                        case .success(let links):
                            self.createMonthlys(links)
                            self.totalContributions = links.count
                            self.isLoading = false
                            self.terminalText = ""
                        case .failure(let error):
                            self.isLoading = false
                            self.terminalText = error.localizedDescription
                        }
                    }
                case .failure(let failure):
                    self.terminalText = failure.localizedDescription
                }
            }
        case .read(let id):
            isLoading = false
            for monthly in monthlys {
                for link in monthly.links {
                    if link.id == id {
                        let isValid = openURL(urlString: link.url)
                        self.terminalText = isValid ? "" : "유효하지 않은 URL"
                    }
                }
            }
        case .delete(let id):
            isLoading = true
            terminalText = "Deleting..."
            for monthly in monthlys {
                for link in monthly.links {
                    if link.id == id {
                        CloudService.shared.deleteLink(link.recordID) { result in
                            
                            switch result {
                            case .success:
                                CloudService.shared.fetchLinks { result in
                                    switch result {
                                    case .success(let links):
                                        self.createMonthlys(links)
                                        self.totalContributions = links.count
                                        self.isLoading = false
                                        self.terminalText = ""
                                    case .failure(let error):
                                        self.isLoading = false
                                        self.terminalText = error.localizedDescription
                                    }
                                }
                            case .failure(let failure):
                                self.terminalText = failure.localizedDescription
                            }
                        }
                    }
                }
            }
            
        case .help:
            isLoading = false
        case .error(let message):
            isLoading = false
            terminalText = message
        case .done:
            isLoading = false
            terminalText = "Input Command"
        case .invalid(let message):
            isLoading = false
            terminalText = message
        }
    }
    
    private func openURL(urlString: String) -> Bool {
        guard let url = URL(string: urlString) else {
            return false
        }
        
        return NSWorkspace.shared.open(url)
    }
}

// MARK: - CloudSerivce 관련 로직
extension HomeViewModel {
}

// MARK: - Date 관련 로직
extension HomeViewModel {
    
    /// Link 데이터로 Monthlys 데이터를 만듦
    /// - Parameter links: [Link] 데이터
    func createMonthlys(_ links: [URLLink]) {
        
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
    
    /// 일수만큼 배열을 만들고 각 일수마다 Link가 얼마나 등록됐는지 카운트
    /// - Parameters:
    ///   - days: 총 일수
    ///   - links: [URLLink] 데이터
    /// - Returns: 일수
    func assignLinkToDays(days: Int, links: [URLLink]) -> [Int] {
        var array = Array(repeating: 0, count: days)
        
        for link in links {
            array[link.date.currentDay()-1] += 1
        }
        
        return array
    }
}

struct TerminalCommandManager {
    
    static let shared = TerminalCommandManager()
    private init() {}
    
    func inputCommand(_ command: String) -> TerminalState {
        let cmds = command.trimmingCharacters(in: .whitespaces).split(separator: " ").map { String($0) }
        
        if cmds.count == 0 { return .done } // 입력한 명령어가 없음
        
        guard let cmd = TerminalCommand(rawValue: cmds[0]) else {
            return .invalid(message: "\(cmds[0]) is invalid command") // 존재하지 않는 명령어
        }
        
        switch cmd {
        case .help:
            return .help
        case .create:
            return create(cmds)
        case .read:
            return read(cmds)
        case .delete:
            return delete(cmds)
        case .refresh:
            return .load
        }
    }
    
    private func create(_ cmd: [String]) -> TerminalState {
        if cmd.count != 3 { return .invalid(message: "매개변수 개수 에러") }
        else { return .create(title: cmd[1], url: cmd[2])}
    }
    
    private func read(_ cmd: [String]) -> TerminalState {
        
        guard cmd.count == 2 else { return .invalid(message: "매개변수 개수 에러") }
        guard let id = Int(cmd[1]) else { return .invalid(message: "번호 입력 에러") }
        
        return .read(id: id)
    }
    
    private func delete(_ cmd: [String]) -> TerminalState {
        
        guard cmd.count == 2 else { return .invalid(message: "매개변수 개수 에러") }
        guard let id = Int(cmd[1]) else { return .invalid(message: "번호 입력 에러") }
        
        return .delete(id: id)
    }
    
}
