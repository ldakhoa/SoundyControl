//
//  Image+Style.swift
//  SoundyControl
//
//  Created by Khoa Le on 29/06/2022.
//

import SwiftUI

extension Image {
    func makeStyle(with colorScheme: ColorScheme) -> some View {
        self
            .foregroundColor(colorScheme == .dark ? .white.opacity(0.5) : .gray)
    }
}
