//
//  SimplyCoreAudio.swift
//  SoundyControl
//
//  Created by Khoa Le on 22/06/2022.
//

import SimplyCoreAudio

extension SimplyCoreAudio {
    static let inputMuting = SimplyCoreAudio().defaultInputDevice?.virtualMainVolume(scope: .input) == 0
    static let outputMuting = SimplyCoreAudio().defaultOutputDevice?.virtualMainVolume(scope: .output) == 0
    static let defaultInputVolume = SimplyCoreAudio().defaultInputDevice?.virtualMainVolume(scope: .input) ?? 0
    static let defaultOutputVolume = SimplyCoreAudio().defaultOutputDevice?.virtualMainVolume(scope: .output) ?? 0
    
    static func setVirtualMainInputVolume(volume: Float32) {
        SimplyCoreAudio().defaultInputDevice?.setVirtualMainVolume(volume, scope: .input)
    }
    
    static func setVirtualMainOutputVolume(volume: Float32) {
        SimplyCoreAudio().defaultOutputDevice?.setVirtualMainVolume(volume, scope: .output)
    }
}
