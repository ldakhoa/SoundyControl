//
//  DeviceTable.swift
//  SoundyControl
//
//  Created by Khoa Le on 22/06/2022.
//

import Foundation

struct DeviceTable: Identifiable {
    let id = UUID()
    let name: String
    let type: String
}
