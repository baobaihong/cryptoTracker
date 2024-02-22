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
    
    var statistics: [StatisticModel] = []
    var allCoins: [CoinModel] = [] {
        didSet {
            self.allCoinsPublisher.send(allCoins)
        }
    }
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
    
    // data service responsible for downloading and decode JSON
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellables = Set<AnyCancellable>()
    
    // Core Data Service for user's portfolio
    private let portfolioDataService = PortfolioDataService()
    
    private var allCoinsPublisher = CurrentValueSubject<[CoinModel], Never>([])
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        /* because the searchTextPublish has already do the job, this first publisher is no longer needed
         // dataService.$allCoins
         //     .sink { [weak self] returnedCoins in
         //         self?.allCoins = returnedCoins
         //      }
         //      .store(in: &cancellables)
         */
        
        // Combine the searchTextPublisher and coinDataService
        searchTextPublisher
            .combineLatest(coinDataService.$allCoins) // this subscriber now subscribe both searchTextPublisher and allCoins. Either of publisher updates, this subscriber will receive the updates and perform task below
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // To improve efficiency, use debounce to wait for 0.5 seconds before preforming tasks
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // Subscriber of marketDataService
        marketDataService.$marketData
        // map GlobalData -> MarketDataModel
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
        
        // Subscriber of portfolio, update portfolioCoins: core data -> view model
        allCoinsPublisher
            .combineLatest(portfolioDataService.$savedEntities) // since portfolioDataService only updates as PortfolioEntity type, but we need to store the portfolio coins as CoinModel type, therefore allCoins(the filtered version of all coins fetched) need to be combined
            .map { coinModels, portfolioEntities -> [CoinModel] in
                coinModels
                    .compactMap { coin -> CoinModel? in
                        guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                            return nil
                        }
                        return coin.updateHoldings(amount: entity.amount) // only update the 'currentHolding' property of this CoinModel and return it.
                    }
            }
            .sink { [weak self] returnedCoins in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
        
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
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
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        guard let data = marketDataModel else { return stats }
        let marketCap = StatisticModel(
            title: "Market Cap",
            value: data.marketCap,
            percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(
            title: "24h Volume",
            value: data.volume)
        let btcDominance = StatisticModel(
            title: "BTC Dominance",
            value: data.btcDominance)
        let portfolio = StatisticModel(
            title: "Portfolio Value",
            value: "$0.00",
            percentageChange: 0)
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio,
        ])
        return stats
    }
    
}
