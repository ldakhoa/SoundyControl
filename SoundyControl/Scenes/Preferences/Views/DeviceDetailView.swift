//
//  DeviceDetailView.swift
//  SoundyControl
//
//  Created by Khoa Le on 20/06/2022.
//

import SwiftUI
import SimplyCoreAudio

struct DeviceDetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var device: SoundyAudioDevice
    @State private var isOutputMute: Bool = SimplyCoreAudio.outputMuting
    @State private var isInputMute: Bool = SimplyCoreAudio.inputMuting
    
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
                clockSourceView()
                sampleRateView()
            }
            
            if device.isDefaultDevice {
                Divider()
                
                if device.isDefaultOutputDevice {
                    outputVolumeView()
                }
                
                if device.isDefaultInputDevice {
                    inputVolumeView()
                }
                
                Divider()
                
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
            
#if DEBUG
            if !device.isDefaultDevice {
                Divider()
                Button {
                    
                } label: {
                    Text(device.isOutputOnlyDevice ? "Set as default output" : "Set as default input")
                }
            }
#endif
            
        }
        .padding()
        .navigationTitle("Soundy Control")
        
        Spacer()
    }
    
    private func defaultView(type: String) -> some View {
        Text("(*) This is the default \(type) device.")
            .font(.subheadline).italic()
    }
    
    private func clockSourceView() -> some View {
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
        .disabled(device.clockSourceIDs.count <= 1)
    }
    
    private func sampleRateView() -> some View {
        Picker("Sample Rate:", selection: $device.nominalSampleRate) {
            ForEach(device.nominalSampleRates, id: \.self) { sampleRate in
                Text(sampleRate.kHertzs)
            }
        }
        .disabled(device.nominalSampleRates.count <= 1)
    }
    
    private func outputVolumeView() -> some View {
        volumeView(
            volumeContent: "Output Volume: \(String(format: "%.f", device.outputDeviceVolume * 100))%",
            value: $device.outputDeviceVolume,
            leadingImageName: "speaker.wave.1.fill",
            trailingImageName: "speaker.wave.3.fill"
        )
    }
    
    private func inputVolumeView() -> some View {
        volumeView(
            volumeContent: "Input Volume: \(String(format: "%.f", device.inputDeviceVolume * 100))%",
            value: $device.inputDeviceVolume,
            leadingImageName: "mic.fill",
            trailingImageName: "mic.and.signal.meter.fill"
        )
    }
    
    private func volumeView(
        volumeContent: String,
        value: Binding<Float32>,
        leadingImageName: String,
        trailingImageName: String
    ) -> some View {
        HStack {
            Text(volumeContent)
            Spacer()
            HStack {
                Image(systemName: leadingImageName)
                    .makeStyle(with: colorScheme)
                    .onTapGesture {
                        if device.isDefaultOutputDevice {
                            device.outputDeviceVolume = 0
                        } else if device.isDefaultInputDevice {
                            device.inputDeviceVolume = 0
                        }
                    }

                Slider(
                    value: value,
                    in: 0...1,
                    step: 0.1)
                .blendMode(colorScheme == .dark ? .plusLighter :.normal)
                .frame(width: 150)
                
                Image(systemName: trailingImageName)
                    .makeStyle(with: colorScheme)
                    .onTapGesture(perform: {
                        if device.isDefaultOutputDevice {
                            device.outputDeviceVolume = 1
                        } else if device.isDefaultInputDevice {
                            device.inputDeviceVolume = 1
                        }
                    })
            }
        }
    }
    
    private func makeImage(imageName: String) -> some View {
        Image(systemName: imageName)
            .foregroundColor(colorScheme == .dark ? .white.opacity(0.5) : .gray)
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

#if DEBUG
struct DeviceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceDetailView(device: SoundyAudioDevice.defaultDevice)
    }
}
#endif
