//
//  StatusBarController.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/11/24.
//

import Foundation
import SwiftUI
import AppKit
import Cocoa

class StatusBarController {
    private(set) var statusItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private(set) var popover: NSPopover = NSPopover()
    
    init() {
        self.popover.contentSize = NSSize(width: 300, height: 300)
        self.popover.contentViewController = NSHostingController(rootView: MenuBarView())
        self.popover.behavior = .transient
        
        if let button = statusItem.button {
            button.image = NSImage(resource: .sample)
            button.image?.size = NSSize(width: 20, height: 18)
            button.imagePosition = .imageLeading
            button.action = #selector(showApp(sender:))
            button.target = self
        }
        
        setupObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension StatusBarController {
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleImageChange), name: .statusItemImageShouldChange, object: nil)
    }
    
    @objc private func handleImageChange() {
        if let button = statusItem.button {
            let images = ["house", "heart", "circle", "folder"]
            let image = NSImage(systemSymbolName: images.randomElement()!, accessibilityDescription: nil)
            button.image = image
        }
    }
    
    @objc func showApp(sender: AnyObject) {
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: statusItem.button!.bounds, of: statusItem.button!, preferredEdge: .maxY)
        }
    }
}
