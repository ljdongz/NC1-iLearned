//
//  TerminalCommand.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/16/24.
//

import Foundation

enum TerminalCommand: String {
    case help = "help"
    case create = "create"
    case read = "read"
    case delete = "delete"
    case refresh = "refresh"
}

enum CommandError: Error {
    case invalid
}
