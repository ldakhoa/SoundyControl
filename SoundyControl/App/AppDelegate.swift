//
//  AppDelegate.swift
//  SoundyControl
//
//  Created by Khoa Le on 22/06/2022.
//

import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    private lazy var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    private var popOver: NSPopover = {
        let view = NSPopover()
        view.contentSize = .init(width: 400, height: 600)
        view.behavior = .transient
        return view
    }()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let statusButton = statusItem.button {
            statusButton.image = NSImage(systemSymbolName: "hifispeaker.2.fill", accessibilityDescription: "Sound Control App")
        }
        statusItem.menu = makeNSMenu()
    }
    
    private func makeNSMenu() -> NSMenu {
        let menuView = NSHostingController(rootView: MenuView()
            .environmentObject(DeviceViewModel())
        )
        menuView.view.frame.size = .init(width: 300, height: 600)
        let menu = NSMenu()
        let menuItem = NSMenuItem()
        menuItem.view = menuView.view
        menu.addItem(menuItem)
        
        menu.addItem(NSMenuItem.separator())
       
        let aboutMenuItem = NSMenuItem(title: "About", action: #selector(onAbout), keyEquivalent: "")
        aboutMenuItem.target = self
        menu.addItem(aboutMenuItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let preferencesMenuItem = NSMenuItem(title: "Preferences...", action: #selector(onPreferences), keyEquivalent: ",")
        preferencesMenuItem.target = self
        menu.addItem(preferencesMenuItem)
       
        menu.addItem(NSMenuItem.separator())
        
        let quitMenuItem = NSMenuItem(title: "Quit", action: #selector(onQuit), keyEquivalent: "q")
        quitMenuItem.target = self
        menu.addItem(quitMenuItem)
        return menu
    }
    
    @objc private func onQuit() {
        NSApp.terminate(self)
    }
    
    @objc private func onAbout() {
        NSApp.orderFrontStandardAboutPanel()
    }
    
    @objc private func onPreferences() {
        NSApp.sendAction(Selector(("showPreferencesWindow")), to: nil, from: nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSApp.setActivationPolicy(.accessory)
        return false
    }
}
