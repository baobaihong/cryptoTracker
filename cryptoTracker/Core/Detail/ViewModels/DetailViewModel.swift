//
//  DetailViewModel.swift
//  cryptoTracker
//
//  Created by Jason on 2024/2/23.
//

import Foundation
import Combine

@Observable
class DetailViewModel {
    let coin: CoinModel
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .sink { returnedCoinDetails in
                print("received coin detail data")
                print(returnedCoinDetails)
            }
            .store(in: &cancellables)
    }
}
