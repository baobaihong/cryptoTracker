//
//  CoinImageView.swift
//  cryptoTracker
//
//  Created by Jason on 2024/2/19.
//

import SwiftUI



struct CoinImageView: View {
    
    @State var vm: CoinImageViewModel
    
    init(coin: CoinModel) {
        _vm = State(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if vm.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundStyle(Color.theme.secondaryText)
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CoinImageView(coin: pd().coin)
        .padding()
}
