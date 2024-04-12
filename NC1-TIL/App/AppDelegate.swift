//
//  AppDelegate.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/11/24.
//

import Foundation
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusBar: StatusBarController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBar = StatusBarController()
        
    }
}
