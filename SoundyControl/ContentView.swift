//
//  ContentView.swift
//  SoundyControl
//
//  Created by Khoa Le on 20/06/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            ForEach(0..<2) { _ in
                VStack(alignment: .leading, spacing: 3) {
                    Label("Test", systemImage: "mic.fill")
                        .font(.headline)
                        .layoutPriority(1)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
