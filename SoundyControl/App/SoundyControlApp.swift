//
//  SoundyControlApp.swift
//  SoundyControl
//
//  Created by Khoa Le on 20/06/2022.
//

import SwiftUI

@main
struct SoundyControlApp: App {
    @StateObject private var deviceViewModel = DeviceViewModel()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .frame(minWidth: 300, idealWidth: 650, minHeight: 300)
                .environmentObject(deviceViewModel)
        }
        .commands {
            SidebarCommands()
        }
    }
}
