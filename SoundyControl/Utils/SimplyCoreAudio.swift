//
//  SimplyCoreAudio.swift
//  SoundyControl
//
//  Created by Khoa Le on 22/06/2022.
//

import SimplyCoreAudio

extension SimplyCoreAudio {
    static func setVirtualMainInputVolume(volume: Float32) {
        SimplyCoreAudio().defaultInputDevice?.setVirtualMainVolume(volume, scope: .input)
    }
    
    static func setVirtualMainOutputVolume(volume: Float32) {
        SimplyCoreAudio().defaultOutputDevice?.setVirtualMainVolume(volume, scope: .output)
    }
}
