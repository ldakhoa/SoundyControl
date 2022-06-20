//
//  DeviceItem.swift
//  SoundyControl
//
//  Created by Khoa Le on 20/06/2022.
//

import SwiftUI
import SimplyCoreAudio

struct DeviceItem: View {
    
    @ObservedObject var device: SoundyAudioDevice
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Label(device.name, systemImage: device.systemImageName)
                .font(.headline)
                .layoutPriority(1)
            
            DeviceSubheaderView(device: device)
        }
        .padding(12)
    }
}

struct DeviceItem_Previews: PreviewProvider {
    static var previews: some View {
        DeviceItem(device: SoundyAudioDevice.defaultDevice)
    }
}
