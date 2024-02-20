//
//  HomeViewModel.swift
//  cryptoTracker
//
//  Created by Jason on 2024/2/18.
//

import Foundation
import Combine
import SwiftUI

@Observable class HomeViewModel {
    var allCoins: [CoinModel] = []
    var portfolioCoins: [CoinModel] = []
    
    // declare a publish var and a binding at the same time
    /*
     How to declare a publisher inside @Observable macro?
     1. Create a custom publisher(use CurrentValueSubject or PassthroughSubject, the former one keeps the latest value and emit the initial value as long as the subscriber connects)
     2. Use didSet to send the current value to publisher
     */
    var searchText = "" {
        didSet {
            self.searchTextPublisher.send(searchText)
        }
    }
    var bindingSearchText: Binding<String> {
        Binding(
            get: { self.searchText },
            set: { self.searchText = $0 }
        )
    }
    private var searchTextPublisher = CurrentValueSubject<String, Never>("")
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        // because the searchTextPublish has already do the job, this first publisher is no longer needed
        // dataService.$allCoins
        //     .sink { [weak self] returnedCoins in
        //         self?.allCoins = returnedCoins
        //      }
        //      .store(in: &cancellables)
        
        searchTextPublisher
            .combineLatest(dataService.$allCoins)
            // this subscriber now subscribe both searchTextPublisher and allCoins
            // either of publisher updates, this subscriber will receive the updates and perform task below
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            // To improve efficiency, use debounce to wait for 0.5 seconds before preforming tasks
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        return coins.filter { coin -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
}
