//
//  TerminalCommandManager.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/18/24.
//

import Foundation


struct TerminalCommandManager {
    
    static let shared = TerminalCommandManager()
    private init() {}
    
    func inputCommand(_ text: String) -> TerminalState {
        let command = text.split(separator: " ").map { String($0) }
        
        if command.count == 0 { return .done } // 입력한 명령어가 없음
        
        guard let mainCommand = TerminalCommand(rawValue: command[0]) else {
            return .invalid(message: "\(command[0]) is invalid command") // 존재하지 않는 명령어
        }
        
        switch mainCommand {
        case .help:
            return .help
        case .create:
            return create(text)
        case .read:
            return read(command)
        case .delete:
            return delete(command)
        case .refresh:
            return .load
        }
    }
}

extension TerminalCommandManager {
    
    /// Create 커멘드 명령 로직
    /// - Parameter text: 기존 터미널에 입력한 Text
    /// - Returns: TerminalState
    private func create(_ text: String) -> TerminalState {
        let command = text.split(separator: "\"").map { String($0).trimmingCharacters(in: .whitespaces) }
        if command.count != 3 { return .invalid(message: "매개변수 개수 에러") }
        else { return .create(title: command[1], url: command[2]) }
    }
    
    /// Read 커멘드 명령 로직
    /// - Parameter cmd: 터미널에 입력한 Text를 " "로 split한 문자열 배열
    /// - Returns: TerminalState
    private func read(_ cmd: [String]) -> TerminalState {
        
        guard cmd.count == 2 else { return .invalid(message: "매개변수 개수 에러") }
        guard let id = Int(cmd[1]) else { return .invalid(message: "번호 입력 에러") }
        
        return .read(id: id)
    }
    
    /// Delete 커멘트 명령 로직
    /// - Parameter cmd: 터미널에 입력한 Text를 " "로 split한 문자열 배열
    /// - Returns: TerminalState
    private func delete(_ cmd: [String]) -> TerminalState {
        
        guard cmd.count == 2 else { return .invalid(message: "매개변수 개수 에러") }
        guard let id = Int(cmd[1]) else { return .invalid(message: "번호 입력 에러") }
        
        return .delete(id: id)
    }
}
