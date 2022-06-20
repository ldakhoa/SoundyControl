//
//  ContentView.swift
//  SoundyControl
//
//  Created by Khoa Le on 20/06/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var deviceViewModel: DeviceViewModel
    @State var selectedDevice: SoundyAudioDevice?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(deviceViewModel.devices, id: \.self) { device in
                    NavigationLink(
                        destination: DeviceDetailView(device: device),
                        tag: device,
                        selection: $selectedDevice
                    ) {
                        DeviceItem(device: device)
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



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DeviceViewModel())
    }
}
