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
}

extension TerminalCommandManager {
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
