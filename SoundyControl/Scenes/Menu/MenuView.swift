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
    @State private var inputVolume: Float32 = .defaultInput
    @State private var outputVolume: Float32 = .defaultOutput
    @State private var isInputMute: Bool = false
    @State private var isOutputMute: Bool = false
    @State private var inputDeviceSelect: SoundyAudioDevice = .defaultInputDevice
    @State private var outputDeviceSelect: SoundyAudioDevice = .defaultDevice
    
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
                outputVolumeView()
                List(selection: $outputDeviceSelect, content: {
                    ForEach(outputDevices, id: \.self) { device in
                        DeviceMenuRow(device: device)
                    }
                })
                .onChange(of: outputDeviceSelect) { newOutputDevice in
                    newOutputDevice.isDefaultOutputDevice = true
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
    
    private func outputVolumeView() -> some View {
        SimplyCoreAudio.setVirtualMainOutputVolume(volume: isOutputMute ? 0 : outputVolume)
        let outputVolumeStr = String(format: "%.f", outputVolume * 100)
        let content = "Output Volume: \(outputVolumeStr)%"
        return volumeView(
            volumeContent: content,
            value: $outputVolume,
            toggleMute: $isOutputMute,
            leadingImageName: "mic.fill",
            trailingImageName: "mic.and.signal.meter.fill"
        ) { _ in
            SimplyCoreAudio.setVirtualMainOutputVolume(volume: outputVolume)
        }
    }
    
    private func inputVolumeView() -> some View {
        SimplyCoreAudio.setVirtualMainInputVolume(volume: isInputMute ? 0 : inputVolume )
        let inputVolumeStr = String(format: "%.f", inputVolume * 100)
        let content = "Input Volume: \(inputVolumeStr)%"
        return volumeView(
            volumeContent: content,
            value: $inputVolume,
            toggleMute: $isInputMute,
            leadingImageName: "speaker.wave.1.fill",
            trailingImageName: "speaker.wave.3.fill"
        ) { _ in
            SimplyCoreAudio.setVirtualMainInputVolume(volume: inputVolume)
        }
    }
    
    private func volumeView(
        volumeContent: String,
        value: Binding<Float32>,
        toggleMute: Binding<Bool>,
        leadingImageName: String,
        trailingImageName: String,
        onEditingChanged: @escaping (Bool) -> Void
    ) -> some View {
        return VStack(alignment: .leading) {
            HStack {
                Text(volumeContent)
                Spacer()
                Toggle("Mute", isOn: toggleMute)
            }
            Spacer()
            HStack {
                Image(systemName: leadingImageName)
                    .foregroundColor(.white.opacity(0.5))
                Slider(
                    value: value,
                    in: 0...1,
                    step: 0.1, onEditingChanged: { changed in
                        onEditingChanged(changed)
                    })
                .blendMode(.plusLighter)
            
                Image(systemName: trailingImageName)
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
