//
//  ContentView.swift
//  cryptoTracker
//
//  Created by Jason on 2024/2/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack(spacing: 16.0) {
                Text("Accent Color")
                    .foregroundStyle(Color.theme.accent)
                Text("Secondary Text Color")
                    .foregroundStyle(Color.theme.secondaryText)
                Text("Red Color")
                    .foregroundStyle(Color.theme.red)
                Text("Green Color")
                    .foregroundStyle(Color.theme.green)
            }
            .font(.headline)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
