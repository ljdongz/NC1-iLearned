//
//  NC1_TILApp.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/11/24.
//

import SwiftUI

@main
struct NC1_TILApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
