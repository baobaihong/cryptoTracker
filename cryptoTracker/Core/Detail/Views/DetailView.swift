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
    @State var vm: DetailViewModel
    
    init(coin: CoinModel) {
        self._vm = State(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20.0) {
                
            }
        }
        .navigationTitle(vm.coin.name)
    }
}

#Preview {
    NavigationStack {
        DetailView(coin: pd().coin)
    }
}
