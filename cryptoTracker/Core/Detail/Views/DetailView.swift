//
//  DetailView.swift
//  cryptoTracker
//
//  Created by Jason on 2024/2/23.
//

import SwiftUI

// to make the actual detail view have that coinModel, create a loading view to unbind the coin
struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        print("initializing detail view for: \(coin.name)")
    }
    
    var body: some View {
        Text(coin.name)
    }
}

#Preview {
    DetailView(coin: pd().coin)
}
