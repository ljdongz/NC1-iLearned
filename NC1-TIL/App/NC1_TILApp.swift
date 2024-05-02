//
//  NC1_TILApp.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/11/24.
//

import SwiftUI

@main
struct NC1_TILApp: App {
    @Environment(\.openWindow) private var openWindow
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        WindowGroup(id: "help") {
            CommandHelpView()
        }
        .commands {
            CommandGroup(after: .help) {
                Button {
                    openWindow(id: "help")
                } label: {
                    Text("Terminal Commands Help")
                }
            }
        }
        
        MenuBarExtra("", systemImage: "link") {
            MenuBarView()
        }
        .menuBarExtraStyle(.window)
    }
}

