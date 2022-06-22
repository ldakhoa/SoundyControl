//
//  AppDelegate.swift
//  SoundyControl
//
//  Created by Khoa Le on 22/06/2022.
//

import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    private var statusItem: NSStatusItem!
    
    private var popOver: NSPopover = {
        let view = NSPopover()
        view.contentSize = .init(width: 300, height: 500)
        view.behavior = .transient
        return view
    }()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let statusButton = statusItem.button {
            statusButton.image = NSImage(systemSymbolName: "headphones.circle", accessibilityDescription: "Sound Control App")
            statusButton.action = #selector(togglePopover)
        }
        popOver.contentViewController = NSHostingController(rootView: MenuView().environmentObject(DeviceViewModel()))
    }
    
    @objc private func togglePopover(button: NSStatusBarButton) {
        if popOver.isShown {
            self.popOver.performClose(nil)
        } else {
            popOver.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
}
