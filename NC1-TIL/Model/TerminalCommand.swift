//
//  TerminalCommand.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/16/24.
//

import Foundation

// 터미널 명령어
enum TerminalCommand: String {
    case help = "help"
    case create = "create"
    case read = "read"
    case delete = "delete"
    case refresh = "refresh"
}

// 터미널 상태
enum TerminalState {
    case load
    case create(title: String, url: String)
    case read(id: Int)
    case delete(id: Int)
    case help
    case error(message: String)
    case done
    case invalid(message: String)
}

enum CommandError: Error {
    case invalid
}
