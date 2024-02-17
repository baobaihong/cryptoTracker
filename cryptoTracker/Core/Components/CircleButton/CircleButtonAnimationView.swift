//
//  CircleButtonAnimationView.swift
//  cryptoTracker
//
//  Created by Jason on 2024/2/17.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
        // only animate one-way
            .animation(animate ? Animation.easeOut(duration: 1.0) : .none, value: animate)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CircleButtonAnimationView(animate: .constant(false))
        .foregroundStyle(.red)
        .frame(width: 100, height: 100)
}
