//
//  MenuView.swift
//  SoundyControl
//
//  Created by Khoa Le on 22/06/2022.
//

import SwiftUI
import SimplyCoreAudio
import AudioToolbox

struct MenuView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var deviceViewModel: DeviceViewModel
    private let simplyCoreAudio = SimplyCoreAudio()
    @State private var selectedOutputDevice = Set<SoundyAudioDevice.ID>()
    @State private var selectedInputDevice = Set<SoundyAudioDevice.ID>()
    
    var body: some View {
        VStack(alignment: .leading) {
            let outputDevices = devices(type: .output)
            let inputDevices = devices(type: .input)
            
            if let outputDevice = outputDevices.filter { $0.isDefaultOutputDevice }.first {
                let outputView = VolumeView(volumeType: .output, device: outputDevice)
                mainVolumeView(
                    devices: outputDevices,
                    tableSelection: $selectedOutputDevice,
                    title: "Output",
                    deviceView: outputView)
            }
            
            Divider()
            
            if let inputDevice = outputDevices.filter { $0.isDefaultInputDevice }.first {
                let inputView = VolumeView(volumeType: .input, device: inputDevice)
                mainVolumeView(
                    devices: inputDevices,
                    tableSelection: $selectedInputDevice,
                    title: "Input",
                    deviceView: inputView)
            }
        }
        .padding()
    }
    
    private func devices(type: SoundyAudioDevice.VolumeType) -> [SoundyAudioDevice] {
        let soundyDevices = type == .output ?
            simplyCoreAudio.allOutputDevices.map { SoundyAudioDevice(device: $0) } :
            simplyCoreAudio.allInputDevices.map { SoundyAudioDevice(device: $0) }
            
        let devices = soundyDevices.filter { device in
            device.transportType == .bluetooth || device.transportType == .usb || device.transportType == .builtIn || device.transportType == .unknown
        }.sorted { device1, device2 in
            type == .output ? device1.isDefaultOutputDevice : device1.isDefaultInputDevice
        }
        return devices
    }
    
    private func mainVolumeView(
        devices: [SoundyAudioDevice],
        tableSelection: Binding<Set<SoundyAudioDevice.ID>>,
        title: String,
        deviceView: some View
    ) -> some View {
        VStack {
            Text(title)
                .font(.headline)
            deviceView
            Table(devices, selection: tableSelection) {
                TableColumn("Name", value: \.name)
                TableColumn("Type", value: \.transportType!.rawValue)
            }
            .onChange(of: selectedOutputDevice) { newValue in
                if let id = newValue.map({ AudioObjectID($0) }).first,
                   let outputDevice = devices.filter({ $0.id == id }).first {
                    outputDevice.isDefaultOutputDevice = true
                }
            }
        }
    }
}

struct VolumeView: View {
    let volumeType: SoundyAudioDevice.VolumeType
    @Environment(\.colorScheme) private var colorScheme
    @State private var isOutputMute: Bool = SimplyCoreAudio.outputMuting
    @State private var isInputMute: Bool = SimplyCoreAudio.inputMuting
    @ObservedObject var device: SoundyAudioDevice
    
    var body: some View {
        volumeType == .output ? AnyView(outputView()) : AnyView(inputView())
    }
        
    private func outputView() -> some View {
        SimplyCoreAudio.setVirtualMainOutputVolume(volume: isOutputMute ? 0 : device.outputDeviceVolume)
        let outputVolumeStr = String(format: "%.f", device.outputDeviceVolume * 100)
        print(outputVolumeStr)
        let content = "Output Volume: \(outputVolumeStr)%"
        return volumeView(
            volumeContent: content,
            value: $device.outputDeviceVolume,
            toggleMute: $isOutputMute,
            leadingImageName: "speaker.wave.1.fill",
            trailingImageName: "speaker.wave.3.fill"
        )
    }
    
    private func inputView() -> some View {
        SimplyCoreAudio.setVirtualMainInputVolume(volume: isInputMute ? 0 : device.inputDeviceVolume)
        let inputVolumeStr = String(format: "%.f", device.inputDeviceVolume * 100)
        let content = "Input Volume: \(inputVolumeStr)%"
        return volumeView(
            volumeContent: content,
            value: $device.inputDeviceVolume,
            toggleMute: $isInputMute,
            leadingImageName: "mic.fill",
            trailingImageName: "mic.and.signal.meter.fill"
        )
    }
    
    private func volumeView(
        volumeContent: String,
        value: Binding<Float32>,
        toggleMute: Binding<Bool>,
        leadingImageName: String,
        trailingImageName: String
    ) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(volumeContent)
                Spacer()
                Toggle("Mute", isOn: toggleMute)
            }
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
                    step: 0.1
                )
                .blendMode(colorScheme == .dark ? .plusLighter :.normal)
            
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
            Spacer()
        }
        .frame(height: 50)
    }
}

#if DEBUG
struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .environmentObject(DeviceViewModel())
    }
}
#endif
