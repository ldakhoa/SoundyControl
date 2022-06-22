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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(deviceViewModel.devices, id: \.self) { device in
                    NavigationLink(
                        destination: DeviceDetailView(
                            device: device,
                            inputVolume: device.currentInputDeviceVolume ?? 0,
                            outputVolume: device.currentOutputDeviceVolume ?? 0),
                        tag: device,
                        selection: $selectedDevice
                    ) {
                        DeviceSidebarItem(device: device)
                    }
                    .accentColor(.accentColor)
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 250, idealWidth: 250)
            .navigationTitle("Devices")
        }
        .onAppear {
            selectedDevice = deviceViewModel.devices.first
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
            .environmentObject(DeviceViewModel())
    }
}
