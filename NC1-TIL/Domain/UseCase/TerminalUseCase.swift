//
//  TerminalUseCase.swift
//  NC1-TIL
//
//  Created by 이정동 on 7/3/24.
//

import Foundation

// TODO: 각 메서드에 DB 통신 로직 추가 필요
final class TerminalUseCase {
    
    private let cloudService: CloudRepository
    
    init(cloudService: CloudRepository) {
        self.cloudService = cloudService
    }
    
    func create(_ text: String) -> TerminalState {
        let command = text.split(separator: "\"").map { String($0).trimmingCharacters(in: .whitespaces) }
        if command.count != 3 { return .invalid(message: "create command is invalid - create [\"YOUR TITLE\"] [YOUR URL]") }
        else { return .create(title: command[1], url: command[2]) }
    }
    
    func read(_ cmd: [String]) -> TerminalState {
        
        guard cmd.count == 2 else { return .invalid(message: "read command is invalid - read [LINK NUMBER]") }
        guard let id = Int(cmd[1]) else { return .invalid(message: "\(cmd[1]) is not number") }
        
        return .read(id: id)
    }
    
    func delete(_ cmd: [String]) -> TerminalState {
        
        guard cmd.count == 2 else { return .invalid(message: "delete command is invalid - delete [LINK NUMBER]") }
        guard let id = Int(cmd[1]) else { return .invalid(message: "\(cmd[1]) is not number") }
        
        return .delete(id: id)
    }
}
