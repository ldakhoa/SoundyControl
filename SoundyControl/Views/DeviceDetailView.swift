//
//  DeviceDetailView.swift
//  SoundyControl
//
//  Created by Khoa Le on 20/06/2022.
//

import SwiftUI

struct DeviceDetailView: View {
    @ObservedObject var device: SoundyAudioDevice
    
    @State private var inputVolume: Float32
    @State private var outputVolume: Float32
    
    init(device: SoundyAudioDevice, inputVolume: Float32, outputVolume: Float32) {
        self.device = device
        self.inputVolume = inputVolume
        self.outputVolume = outputVolume
    }
    
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
                .disabled(device.clockSourceIDs.count <= 1)
                
                Picker("Sample Rate:", selection: $device.nominalSampleRate) {
                    ForEach(device.nominalSampleRates, id: \.self) { sampleRate in
                        Text(sampleRate.kHertzs)
                    }
                }
                .disabled(device.nominalSampleRates.count <= 1)
            }
            
            if device.isDefaultDevice {
                Divider()
                
                outputVolumeView()
                inputVolumeView()
                
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

        }
        .padding()
        .navigationTitle("Soundy Control")
        
        Spacer()
    }
    
    private func defaultView(type: String) -> some View {
        Text("(*) This is the default \(type) device.")
            .font(.subheadline).italic()
    }
    
    private func outputVolumeView() -> some View {
        HStack {
            let outputVolumeStr = String(format: "%.1f", outputVolume * 100)
            Text("Output Volume: \(outputVolumeStr)%")
            Spacer()
            HStack {
                Image(systemName: "speaker.wave.1.fill")
                    .foregroundColor(.white.opacity(0.5))
                Slider(
                    value: $outputVolume,
                    in: 0...1,
                    step: 0.1)
                .blendMode(.plusLighter)
                .frame(width: 150)
                Image(systemName: "speaker.wave.3.fill")
                    .foregroundColor(.white.opacity(0.5))
            }
        }
    }
    
    private func inputVolumeView() -> some View {
        HStack {
            let inputVolumeString = String(format: "%.1f", inputVolume * 100)
            Text("Input Volume: \(inputVolumeString)%")

            Spacer()
            HStack {
                Image(systemName: "mic.fill")
                    .foregroundColor(.white.opacity(0.5))
                Slider(value: $inputVolume,
                       in: 0...1,
                       step: 0.1)
                .blendMode(.plusLighter)
                .frame(width: 150)
                Image(systemName: "mic.and.signal.meter.fill")
                    .foregroundColor(.white.opacity(0.5))
            }
        }
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
        DeviceDetailView(device: SoundyAudioDevice.defaultDevice, inputVolume: .defaultInput, outputVolume: .defaultOutput)
    }
}
