//
//  ContentView.swift
//  SoundyControl
//
//  Created by Khoa Le on 20/06/2022.
//

import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var deviceViewModel: DeviceViewModel
    @State var selectedDevice: SoundyAudioDevice?
    @State private var launchAtLogin = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(deviceViewModel.devices, id: \.self) { device in
                        NavigationLink(
                            destination: DeviceDetailView(device: device),
                            tag: device,
                            selection: $selectedDevice
                        ) {
                            DeviceSidebarItem(device: device)
                        }
                        .accentColor(.accentColor)
                    }
                    .listRowInsets(EdgeInsets())
                    
                    Spacer()
                }
                .listStyle(SidebarListStyle())
                .frame(minWidth: 250, idealWidth: 250)
                .navigationTitle("Devices")
                
                Spacer()
                
                #if DEBUG
                Divider()
                Toggle(isOn: $launchAtLogin) {
                    Text("Launch at login")
                }
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
                #endif
            }
        }
        .onAppear {
            selectedDevice = deviceViewModel.devices.first
        }
    }
}

#if DEBUG
struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
            .environmentObject(DeviceViewModel())
    }
}
#endif
