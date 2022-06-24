//
//  DeviceSubheaderView.swift
//  SoundyControl
//
//  Created by Khoa Le on 21/06/2022.
//

import SwiftUI

struct DeviceSubheaderView: View {
    var device: SoundyAudioDevice
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Text(device.prettyChannelsDescription)
                .font(.subheadline)
            
            Spacer()
            
            if let transportType = device.transportType {
                Text(transportType.rawValue)
                    .font(.subheadline)
            }
        }
    }
}

#if DEBUG
struct DeviceSubheaderView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceSubheaderView(device: SoundyAudioDevice.defaultDevice)
    }
}
#endif
