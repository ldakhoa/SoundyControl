//
//  MenuDetailView.swift
//  SoundyControl
//
//  Created by Khoa Le on 22/06/2022.
//

import SwiftUI

struct MenuDetailView: View {
    @ObservedObject var device: SoundyAudioDevice
    @State var outputVolume: Float32
    @State private var isOutputMute: Bool = true
    @State var inputVolume: Float32
    @State private var isInputMute: Bool = false

    var body: some View {
        if device.isDefaultDevice {
            if device.isDefaultOutputDevice {
                outputVolumeView()
            }
            if device.isDefaultInputDevice {
                inputVolumeView()
            }
        }
    }
    
    private func outputVolumeView() -> some View {
        VStack(alignment: .leading) {
            Text("Sound")
                .font(.headline)
            HStack {
                let outputVolumeStr = String(format: "%.f", outputVolume * 100)
                Text("Output Volume: \(outputVolumeStr)%")
                Spacer()
                Toggle("Mute", isOn: $isOutputMute)
            }

            Spacer()
            HStack {
                Image(systemName: "speaker.wave.1.fill")
                    .foregroundColor(.white.opacity(0.5))
                Slider(
                    value: $outputVolume,
                    in: 0...1,
                    step: 0.1, onEditingChanged: { _ in
                        device.outputVolume(outputVolume)
                    })
                .blendMode(.plusLighter)
            
                Image(systemName: "speaker.wave.3.fill")
                    .foregroundColor(.white.opacity(0.5))
            }
            Spacer()
        }
        .padding()
    }
    
    private func inputVolumeView() -> some View {
        VStack(alignment: .leading) {
            Text("Input")
                .font(.headline)
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
                        device.inputVolume(inputVolume)
                    })
                .blendMode(.plusLighter)
            
                Image(systemName: "speaker.wave.3.fill")
                    .foregroundColor(.white.opacity(0.5))
            }
            Spacer()
        }
        .padding()
    }
}

struct MenuDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MenuDetailView(device: .defaultInputDevice, outputVolume: .defaultOutput, inputVolume: .defaultInput)
    }
}
