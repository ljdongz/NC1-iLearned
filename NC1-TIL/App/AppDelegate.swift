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
        
        for window in NSApplication.shared.windows {
            window.setContentSize(NSSize(width: 600, height: 450)) // 원하는 윈도우 크기 설정
            window.minSize = NSSize(width: 600, height: 450) // 최소 크기 설정
            window.maxSize = NSSize(width: 600, height: 450) // 최대 크기 설정
        }
    }
}
