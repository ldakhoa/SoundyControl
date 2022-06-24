//
//  DeviceItem.swift
//  SoundyControl
//
//  Created by Khoa Le on 20/06/2022.
//

import SwiftUI
import SimplyCoreAudio

struct DeviceSidebarItem: View {
    
    @ObservedObject var device: SoundyAudioDevice
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            if device.isDefaultDevice {
                
            }
            Label(
                "\(device.isDefaultDevice ? "(*)" : "" ) \(device.name)",
                systemImage: device.systemImageName)
                .font(.headline)
                .layoutPriority(1)
            
            DeviceSubheaderView(device: device)
        }
        .padding(12)
    }
}

#if DEBUG
struct DeviceSidebarItem_Previews: PreviewProvider {
    static var previews: some View {
        DeviceSidebarItem(device: SoundyAudioDevice.defaultDevice)
    }
}
#endif
