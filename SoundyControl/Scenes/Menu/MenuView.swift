//
//  MenuView.swift
//  SoundyControl
//
//  Created by Khoa Le on 22/06/2022.
//

import SwiftUI
import SimplyCoreAudio

struct MenuView: View {
    @EnvironmentObject var deviceViewModel: DeviceViewModel
    private let simplyCoreAudio = SimplyCoreAudio()
//    @State var outputVolume: Float32
//    @State private var isOutputMute: Bool = true
    @State private var inputVolume: Float32 = .defaultInput
    @State private var previousInputVolume: Float32 = .defaultInput
    @State private var isInputMute: Bool = false
    @State private var inputDeviceSelect: SoundyAudioDevice = .defaultInputDevice
    
    var body: some View {
        VStack(alignment: .leading) {
            let outputSoundyDevices = simplyCoreAudio.allOutputDevices.map { SoundyAudioDevice(device: $0) }
            let outputDevices = outputSoundyDevices.filter { device in
                device.transportType == .bluetooth || device.transportType == .usb || device.transportType == .builtIn || device.transportType == .unknown
            }.sorted { device1, device2 in
                device1.isDefaultOutputDevice
            }
            
            let inputSoundyDevices = simplyCoreAudio.allInputDevices.map { SoundyAudioDevice(device: $0) }
            let inputDevices = inputSoundyDevices.filter { device in
                device.transportType == .bluetooth || device.transportType == .usb || device.transportType == .builtIn || device.transportType == .unknown
            }.sorted { device1, device2 in
                device1.isDefaultInputDevice
            }
            
            VStack {
                Text("Output")
                    .font(.headline)
                inputVolumeView()
                List(selection: $inputDeviceSelect, content: {
                    ForEach(outputDevices, id: \.self) { device in
                        DeviceMenuRow(device: device)
                    }
                })
                .onChange(of: inputDeviceSelect) { newInputDevice in
                    newInputDevice.isDefaultInputDevice = true
                }
            }
            
            Divider()
            
            VStack {
                Text("Input")
                    .font(.headline)
                inputVolumeView()
                List(selection: $inputDeviceSelect, content: {
                    ForEach(inputDevices, id: \.self) { device in
                        DeviceMenuRow(device: device)
                    }
                })
                .onChange(of: inputDeviceSelect) { newInputDevice in
                    newInputDevice.isDefaultInputDevice = true
                }
            }
            
        }
        .padding()
    }
    
    private func inputVolumeView() -> some View {
        SimplyCoreAudio.setVirtualMainInputVolume(volume: isInputMute ? 0 : inputVolume )
        
        return VStack(alignment: .leading) {
            HStack {
                let inputVolumeStr = String(format: "%.f", inputVolume * 100)
                Text("Input Volume: \(inputVolumeStr)%")
                Spacer()
                Toggle("Mute", isOn: $isInputMute)
            }

            Spacer()
            HStack {
                Image(systemName: "speaker.wave.1.fill")
                    .foregroundColor(.white.opacity(0.5))
                Slider(
                    value: $inputVolume,
                    in: 0...1,
                    step: 0.1, onEditingChanged: { _ in
                        SimplyCoreAudio.setVirtualMainInputVolume(volume: inputVolume)
                    })
                .blendMode(.plusLighter)
            
                Image(systemName: "speaker.wave.3.fill")
                    .foregroundColor(.white.opacity(0.5))
            }
            Spacer()
        }
        .frame(height: 50)
    }
}

struct DeviceMenuRow: View {
    @ObservedObject var device: SoundyAudioDevice
    
    var body: some View {
        HStack() {
            Text(device.name)
            Spacer()
            Text(device.transportType?.rawValue ?? "Unknown")
        }
        .padding(.all, 8)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .environmentObject(DeviceViewModel())
    }
}
