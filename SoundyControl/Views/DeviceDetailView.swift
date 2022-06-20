//
//  DeviceDetailView.swift
//  SoundyControl
//
//  Created by Khoa Le on 20/06/2022.
//

import SwiftUI

struct DeviceDetailView: View {
    @ObservedObject var device: SoundyAudioDevice
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label {
                Text(device.name)
            } icon: {
                Image(systemName: device.systemImageName)
                    .foregroundColor(.accentColor)
            }
            .font(.title)
            .frame(minHeight: 40)

            DeviceSubheaderView(device: device)

            Divider()

            DeviceDetailInfo(title: "Manufacturer", content: device.manufacturer)
            DeviceDetailInfo(title: "UID", content: device.uid)
            DeviceDetailInfo(title: "Model UID", content: device.modelUID)
            
            Divider()
            
            HStack(alignment: .center) {
                Picker("Clock Source", selection: $device.clockSourceID) {
                    if device.clockSourceIDs.isEmpty {
                        Text(device.clockSourceName)
                            .tag(device.clockSourceID)
                    } else {
                        ForEach(device.clockSourceIDs, id: \.self) { clockSourceID in
                            Text(device.clockSourceName(for: clockSourceID))
                        }
                    }

                }
            }
            
            
            if device.isDefaultDevice {
                if device.isDefaultInputDevice  {
                    defaultView(type: "input")
                }
                
                if device.isDefaultOutputDevice  {
                    defaultView(type: "output")
                }
                
                if device.isDefaultSystemOutputDevice  {
                    defaultView(type: "system output")
                }
            }

        }
        .padding()
        .navigationTitle(device.name)
        
        Spacer()
    }
    
    func defaultView(type: String) -> some View {
        Text("(*) This is the default \(type) device.")
            .font(.subheadline).italic()
    }
}

struct DeviceDetailInfo: View {
    let title: String
    let content: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text("\(title):")
                .frame(minWidth: 100, alignment: .trailing)
            Text(content)
                .bold()
        }
    }
}

struct DeviceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceDetailView(device: SoundyAudioDevice.defaultDevice)
    }
}
