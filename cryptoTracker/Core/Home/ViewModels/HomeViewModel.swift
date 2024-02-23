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
    var isLoading: Bool = false
    var portfolioCoins: [CoinModel] = [] {
        didSet {
            self.portfolioCoinsPublisher.send(portfolioCoins)
        }
    }
    
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
    // publisher for self.allCoins and self.portfolioCoins Publisher
    private var allCoinsPublisher = CurrentValueSubject<[CoinModel], Never>([])
    private var portfolioCoinsPublisher = CurrentValueSubject<[CoinModel], Never>([])
    
    // Sorting functionality
    var sortOption: SortOption = .holdings {
        didSet {
            self.sortOptionPublisher.send(sortOption)
        }
    }
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    private var sortOptionPublisher = CurrentValueSubject<SortOption, Never>(.holdings)
    
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        // 1. update allCoins
        searchTextPublisher
            .combineLatest(coinDataService.$allCoins, sortOptionPublisher) // this subscriber now subscribe both searchTextPublisher and allCoins. Either of publisher updates, this subscriber will receive the updates and perform task below
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // To improve efficiency, use debounce to wait for 0.5 seconds before preforming tasks
            .map(filterAndSortCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // 2. update portfolioCoins
        allCoinsPublisher
            .combineLatest(portfolioDataService.$savedEntities) // since portfolioDataService only updates as PortfolioEntity type, but we need to store the portfolio coins as CoinModel type, therefore allCoins(the filtered version of all coins fetched) need to be combined
            .map(mapAllCoins2PortfolioCoins)
            .sink { [weak self] returnedCoins in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        // 3. update marketDataService
        marketDataService.$marketData
            .combineLatest(portfolioCoinsPublisher)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
                self?.isLoading = false // <- after manually reload, reset the isLoading to false
            }
            .store(in: &cancellables)
        
    }
    
    // Portfolio coins update: view -> viewModel -> core data
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    // manually reload the coin and market data
    func reloadData() {
        isLoading = false
        coinDataService.getCoins()
        marketDataService.getMarketData()
        HapticManager.notification(type: .success)
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        //sort in place to improve efficiency
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) { // inout parameter change the 'coins' parameter directly without creating new
        switch sort {
        case .rank, .holdings:
            coins.sort(by: { $0.rank > $1.rank }) // use .sort instead of .sorted to sort in place
        case .rankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank < $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        // only sort by holdings or reversedholdings if needed
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
    }
    
    // filter searchbar input + coin data service -> allCoins
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
    
    //map allCoins + PortfolioEntity -> PortfolioCoins
    private func mapAllCoins2PortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap { coin -> CoinModel? in
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount) // only update the 'currentHolding' property of this CoinModel and return it.
            }
    }
    
    // map GlobalData + PortfolioCoins -> statistics
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
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
        
        let portfolioValue = // map PortfolioCoins -> sum of the portfolio coins' holding value
        portfolioCoins
            .map({ $0.currentHoldingsValue }) // read current holding value for each portfolio coins
            .reduce(0, +) // calculate the sum of [double]
        
        let previousValue = // calculate the 24H change percentage for portfolio coin holding value
        portfolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentHoldingsValue
                if let percentChange = coin.priceChangePercentage24H { // 25% -> 0.25
                    return currentValue / (1 + percentChange / 100)
                } else {
                    return 0.00
                }
            }
            .reduce(0, +)
        // percentageChange = (new - old) / old
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = StatisticModel(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange)
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio,
        ])
        return stats
    }
    
}
