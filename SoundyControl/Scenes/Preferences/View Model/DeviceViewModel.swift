//
//  DeviceViewModel.swift
//  SoundyControl
//
//  Created by Khoa Le on 20/06/2022.
//

import Foundation
import SimplyCoreAudio

final class DeviceViewModel: ObservableObject {
    @Published var devices = [SoundyAudioDevice]()
     
    private var deviceForDevice = [AudioDevice: SoundyAudioDevice]() {
        didSet {
            devices = [SoundyAudioDevice](deviceForDevice.values.sorted(by: <))
        }
    }
    
    private let simply = SimplyCoreAudio()
    private var observers = [NSObjectProtocol]()
    private let notificationCenter = NotificationCenter.default

    init() {
        for device in simply.allDevices {
            deviceForDevice[device] = SoundyAudioDevice(device: device)
        }
        
        devices = [SoundyAudioDevice](deviceForDevice.values.sorted(by: <)).sorted { $0.name < $1.name }
        #if DEBUG
        deviceForDevice.values.forEach { print($0.name) }
        #endif
        
        updateDefaultInputDevice()
        updateDefaultOutputDevice()
        updateDefaultSystemDevice()

        addObservers()
    }
    
    deinit {
        removeObservers()
    }
    
    func defaultInputDevice() -> SoundyAudioDevice {
        if let device = devices.filter ({ $0.isDefaultInputDevice }).first {
            return device
        }
        return SoundyAudioDevice(device: simply.defaultOutputDevice!)
    }
}

private extension DeviceViewModel {
    func updateDefaultInputDevice() {
        if let defaultInputDevice = simply.defaultInputDevice {
            for device in devices {
                device.isDefaultInputDevice = device.id == defaultInputDevice.id
            }
        }
    }

    func updateDefaultOutputDevice() {
        if let defaultOutputDevice = simply.defaultOutputDevice {
            for device in devices {
                device.isDefaultOutputDevice = device.id == defaultOutputDevice.id
            }
        }
    }

    func updateDefaultSystemDevice() {
        if let defaultSystemDevice = simply.defaultSystemOutputDevice {
            for device in devices {
                device.isDefaultSystemOutputDevice = device.id == defaultSystemDevice.id
            }
        }
    }

    func addObservers() {
        observers.append(contentsOf: [
            notificationCenter.addObserver(forName: .deviceListChanged, object: nil, queue: .main) { (notification) in
                if let addedDevices = notification.userInfo?["addedDevices"] as? [AudioDevice] {
                    for device in addedDevices {
                        self.deviceForDevice[device] = SoundyAudioDevice(device: device)
                    }
                }

                if let removedDevices = notification.userInfo?["removedDevices"] as? [AudioDevice] {
                    for device in removedDevices {
                        self.deviceForDevice.removeValue(forKey: device)
                    }
                }
            },

            notificationCenter.addObserver(forName: .defaultInputDeviceChanged, object: nil, queue: .main) { (_) in
                self.updateDefaultInputDevice()
            },

            notificationCenter.addObserver(forName: .defaultOutputDeviceChanged, object: nil, queue: .main) { (_) in
                self.updateDefaultOutputDevice()
            },

            notificationCenter.addObserver(forName: .defaultSystemOutputDeviceChanged, object: nil, queue: .main) { (_) in
                self.updateDefaultSystemDevice()
            },

            notificationCenter.addObserver(forName: .deviceNominalSampleRateDidChange, object: nil, queue: .main) { notification in
                if let _device = notification.object as? AudioDevice, let device = self.deviceForDevice[_device] {
                    if let nominalSampleRate = _device.nominalSampleRate {
                        device.nominalSampleRate = nominalSampleRate
                    }
                }
            },

            notificationCenter.addObserver(forName: .deviceClockSourceDidChange, object: nil, queue: .main) { notification in
                if let _device = notification.object as? AudioDevice, let device = self.deviceForDevice[_device] {
                    if let clockSourceName = _device.clockSourceName {
                        device.clockSourceName = clockSourceName
                    }
                }
            },
            
            notificationCenter.addObserver(forName: .deviceVolumeDidChange, object: nil, queue: .main, using: { notification in
                
                if let v = self.simply.defaultOutputDevice?.virtualMainVolume(scope: .output) {
//                    print("Change: ", v)
                    for device in self.devices {
                        device.outputDeviceVolume = v
                    }
                }
                
//                if let _device = notification.object as? AudioDevice,
//                   let device = self.deviceForDevice[_device],
//                    let outputVolume = _device.virtualMainVolume(scope: .output) {
//                    device.outputDeviceVolume = outputVolume
//                    print("device volume did change: ", device.outputDeviceVolume)
//                }
            })
        ])
    }

    func removeObservers() {
        for observer in observers {
            notificationCenter.removeObserver(observer)
        }

        observers.removeAll()
    }
}

