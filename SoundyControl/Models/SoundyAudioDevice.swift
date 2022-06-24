//
//  AudioDevice.swift
//  SoundyControl
//
//  Created by Khoa Le on 20/06/2022.
//

import SimplyCoreAudio
import CoreAudio
import Foundation

final class SoundyAudioDevice: ObservableObject {
    @Published var id: AudioObjectID
    @Published var name: String
    @Published var transportType: TransportType?
    @Published var manufacturer: String
    @Published var uid: String
    @Published var modelUID: String
    @Published var clockSourceName: String
    
    @Published var inputChannelCount: UInt32
    @Published var outputChannelCount: UInt32
    
    @Published var isInputOnlyDevice: Bool
    @Published var isOutputOnlyDevice: Bool
    
    @Published var nominalSampleRates = [Float64]()
    @Published var clockSourceIDs = [UInt32]()
    
    @Published var nominalSampleRate: Float64 {
        didSet {
            device.setNominalSampleRate(nominalSampleRate)
        }
    }
    
    @Published var clockSourceID: UInt32 = 0 {
        didSet {
            device.setClockSourceID(clockSourceID)
        }
    }
    
    @Published var isDefaultInputDevice: Bool
    @Published var isDefaultOutputDevice: Bool
    @Published var isDefaultSystemOutputDevice: Bool
    
    var currentOutputDeviceVolume: Float32? {
        SimplyCoreAudio().defaultOutputDevice?.virtualMainVolume(scope: .output)
    }

    var currentInputDeviceVolume: Float32? {
        SimplyCoreAudio().defaultInputDevice?.virtualMainVolume(scope: .input)
    }
    
    private let device: AudioDevice
    
    init(device: AudioDevice) {
        self.device = device
        id = device.id
        name = device.name
        
        transportType = device.transportType
        uid = device.uid ?? "Unknown"
        manufacturer = device.manufacturer ?? "Unknown"
        modelUID = device.modelUID ?? "Unknown"
        clockSourceName = device.clockSourceName ?? "Default"
        
        isInputOnlyDevice = device.isInputOnlyDevice
        isOutputOnlyDevice = device.isOutputOnlyDevice
        
        inputChannelCount = device.channels(scope: .input)
        outputChannelCount = device.channels(scope: .output)
        
        nominalSampleRates = device.nominalSampleRates ?? []
        clockSourceIDs = device.clockSourceIDs ?? []
        
        nominalSampleRate = device.nominalSampleRate ?? 0
        clockSourceID = device.clockSourceID ?? 0
        
        isDefaultInputDevice = device.isDefaultInputDevice
        isDefaultOutputDevice = device.isDefaultOutputDevice
        isDefaultSystemOutputDevice = device.isDefaultSystemOutputDevice
    }
    
    var systemImageName: String {
        isInputOnlyDevice ? "mic.fill" : "speaker.wave.2.fill"
    }
    
    var prettyChannelsDescription: String {
        let inChannelDescription = "\(inputChannelCount) in\(inputChannelCount != 1 ? "s" : "")"
        let outChannelDescription = "\(outputChannelCount) out\(outputChannelCount != 1 ? "s" : "")"

        return "\(inChannelDescription) / \(outChannelDescription)"
    }

    var isDefaultDevice: Bool {
        isDefaultInputDevice || isDefaultOutputDevice || isDefaultSystemOutputDevice
    }
    
    func clockSourceName(for id: UInt32) -> String {
        device.clockSourceName(clockSourceID: id) ?? "Default"
    }
    
    func outputVolume(_ volume: Float32) {
        device.setVirtualMainVolume(volume, scope: .output)
    }
    
    func inputVolume(_ volume: Float32) {
        device.setVirtualMainVolume(volume, scope: .input)
    }
}

extension SoundyAudioDevice: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

func == (lhs: SoundyAudioDevice, rhs: SoundyAudioDevice) -> Bool {
    lhs.hashValue == rhs.hashValue
}

func < (lhs: SoundyAudioDevice, rhs: SoundyAudioDevice) -> Bool {
    lhs.hashValue == rhs.hashValue
}

extension SoundyAudioDevice {
    static let defaultDevice = SoundyAudioDevice(device: SimplyCoreAudio().defaultOutputDevice!)
    static let defaultInputDevice = SoundyAudioDevice(device: SimplyCoreAudio().defaultInputDevice!)
}

extension Float32 {
    static let defaultInput = SimplyCoreAudio().defaultInputDevice?.virtualMainVolume(scope: .input) ?? 0
    static let defaultOutput = SimplyCoreAudio().defaultOutputDevice?.virtualMainVolume(scope: .output) ?? 0
}
