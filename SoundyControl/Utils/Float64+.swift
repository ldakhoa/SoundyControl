//
//  Float64+.swift
//  SoundyControl
//
//  Created by Khoa Le on 21/06/2022.
//

import Foundation

extension Float64 {
    var kHertzs: String {
        String(format: "%.1f kHz", self / 1000)
    }
}
