//
//  HomeViewModel.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/13/24.
//

import Foundation
import AppKit

@Observable
class TerminalViewModel {
    
    enum Action {
        case enterCommand(command: String)
        case onAppear
    }
    
    struct State {
        var isLoading: Bool = false
        var terminalText: String = ""
        var totalContributions: Int = 0
        var monthlys: [Monthly] = []
    }
    
    private let terminalUseCase: TerminalUseCase
    
    private(set) var state: State = .init()
    
    init(terminalUseCase: TerminalUseCase) {
        self.terminalUseCase = terminalUseCase
    }
    
    func effect(_ action: Action) {
        switch action {
        case .enterCommand(let command):
            let commandState = self.validateCommand(command)
            self.handlingCommand(commandState)
        case .onAppear:
            self.handlingCommand(.load)
        }
    }
}

// MARK: - TerminalCommand 관련 로직
extension TerminalViewModel {
    
    private func validateCommand(_ cmd: String) -> CommandState {
        let command = cmd
            .trimmingCharacters(in: .whitespaces)
            .split(separator: " ")
            .map { String($0) }
        
        // 입력한 명령어가 없음
        if command.count == 0 { return .none }
        
        guard let mainCommand = TerminalCommand(rawValue: command[0]) else {
            // 존재하지 않는 명령어
            return .invalid(message: "\(command[0]) is invalid command")
        }
        
        switch mainCommand {
        case .help:
            return .help
        case .create:
            return create(cmd.trimmingCharacters(in: .whitespaces))
            // TODO: TerminalUseCase를 통해 Cloud Create 작업 필요
        case .read:
            return read(command)
            // TODO: Read 작업 필요
        case .delete:
            return delete(command)
            // TODO: TerminalUseCase를 통해 Cloud Delete 작업 필요
        case .refresh:
            return .load
            // TODO: TerminalUseCase를 통해 Cloud Fetch 작업 필요
        }
    }
    
    private func handlingCommand(_ state: CommandState) {
        switch state {
        case .load:
            self.updateTerminalField(text: "Loading ...", isLoading: true)
            
            // TODO: state에 URLLinks 업데이트
            self.terminalUseCase.fetchLinks { result in
                switch result {
                case .success(let success):
                    self.state.monthlys = self.createMonthlys(success)
                    self.updateTerminalField(text: "", isLoading: false)
                    self.state.totalContributions = success.count
                case .failure(let failure):
                    self.updateTerminalField(text: failure.localizedDescription, isLoading: false)
                }
            }
            
        case .create(let title, let url):
            self.updateTerminalField(text: "Creating ...", isLoading: true)
            
            self.terminalUseCase.saveLink(title: title, url: url) { result in
                switch result {
                case .success:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.terminalUseCase.fetchLinks { result in
                            switch result {
                            case .success(let success):
                                self.state.monthlys = self.createMonthlys(success)
                                self.updateTerminalField(text: "", isLoading: false)
                                self.state.totalContributions = success.count
                            case .failure(let failure):
                                self.updateTerminalField(text: failure.localizedDescription, isLoading: false)
                            }
                        }
                    }
                    
                case .failure(let failure):
                    self.updateTerminalField(text: failure.localizedDescription, isLoading: false)
                }
            }
            
        case .read(let id):
            self.updateTerminalField(text: "", isLoading: false)
            for monthly in self.state.monthlys {
                for link in monthly.links {
                    if link.id == id {
                        let isValid = terminalUseCase.openLink(link)
                        let text = isValid ? "Input Command" : "유효하지 않은 URL"
                        self.updateTerminalField(text: text, isLoading: false)
                    }
                }
            }
            
        case .delete(let id):
            self.updateTerminalField(text: "Deleting ...", isLoading: true)
            
            for monthly in self.state.monthlys {
                for link in monthly.links {
                    if link.id == id {
                        self.terminalUseCase.deleteLink(link) { result in
                            switch result {
                            case .success(let success):
                                self.terminalUseCase.fetchLinks { result in
                                    switch result {
                                    case .success(let success):
                                        self.state.monthlys = self.createMonthlys(success)
                                        self.updateTerminalField(text: "", isLoading: false)
                                        self.state.totalContributions = success.count
                                    case .failure(let failure):
                                        self.updateTerminalField(text: failure.localizedDescription, isLoading: false)
                                    }
                                }
                            case .failure(let failure):
                                self.updateTerminalField(text: failure.localizedDescription, isLoading: false)
                            }
                        }
                    }
                }
            }
            
        case .help, .done, .none:
            self.updateTerminalField(text: "", isLoading: false)
            
        case .error(let message), .invalid(let message):
            self.updateTerminalField(text: message, isLoading: false)
        }
    }
    
    private func updateTerminalField(text: String, isLoading: Bool) {
        self.state.terminalText = text
        self.state.isLoading = isLoading
    }
}

extension TerminalViewModel {
    /// Create 커멘드 명령 로직
    /// - Parameter text: 기존 터미널에 입력한 Text
    /// - Returns: TerminalState
    private func create(_ text: String) -> CommandState {
        let command = text.split(separator: "\"").map { String($0).trimmingCharacters(in: .whitespaces) }
        if command.count != 3 { return .invalid(message: "create command is invalid - create [\"YOUR TITLE\"] [YOUR URL]") }
        else { return .create(title: command[1], url: command[2]) }
    }
    
    /// Read 커멘드 명령 로직
    /// - Parameter cmd: 터미널에 입력한 Text를 " "로 split한 문자열 배열
    /// - Returns: TerminalState
    private func read(_ cmd: [String]) -> CommandState {
        
        guard cmd.count == 2 else { return .invalid(message: "read command is invalid - read [LINK NUMBER]") }
        guard let id = Int(cmd[1]) else { return .invalid(message: "\(cmd[1]) is not number") }
        
        return .read(id: id)
    }
    
    /// Delete 커멘트 명령 로직
    /// - Parameter cmd: 터미널에 입력한 Text를 " "로 split한 문자열 배열
    /// - Returns: TerminalState
    private func delete(_ cmd: [String]) -> CommandState {
        
        guard cmd.count == 2 else { return .invalid(message: "delete command is invalid - delete [LINK NUMBER]") }
        guard let id = Int(cmd[1]) else { return .invalid(message: "\(cmd[1]) is not number") }
        
        return .delete(id: id)
    }
}


// MARK: - Date 관련 로직
extension TerminalViewModel {
    
    /// Link 데이터로 Monthlys 데이터를 만듦
    /// - Parameter links: [Link] 데이터
    private func createMonthlys(_ links: [URLLink]) -> [Monthly] {
        
        let dic = groupedLink(links)
        let sortedDic = dic.sorted { $0.key < $1.key }
        
        var newMonthlys: [Monthly] = []
        
        for (key, value) in sortedDic {
            let days = self.assignLinkToDays(days: key.daysInMonth(), links: value)
            newMonthlys.append(Monthly(date: key, days: days, links: value))
        }
        
        return newMonthlys
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
