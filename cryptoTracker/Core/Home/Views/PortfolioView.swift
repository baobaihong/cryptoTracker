//
//  PortfolioView.swift
//  cryptoTracker
//
//  Created by Jason on 2024/2/21.
//

import SwiftUI

struct PortfolioView: View {
    @Environment(HomeViewModel.self) var vm
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0.0) {
                    SearchBarView(searchText: vm.bindingSearchText)
                    coinLogoList
                    
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    trailingNavBarButtons
                }
            }
            
        }
    }
}

extension PortfolioView {
    private var coinLogoList: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation {
                                selectedCoin = coin
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear,
                                        lineWidth: 1)
                        )
                }
            }
            .padding(.vertical, 4)
            .padding(.leading)
        }
        .scrollIndicators(.hidden)
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20.0) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none, value: selectedCoin?.id)
        .padding()
        .font(.headline)
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private var trailingNavBarButtons: some View {
        HStack(spacing: 2) {
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1.0 : 0.0)
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("Save".uppercased())
            })
            .opacity(
                selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ?
                1.0 : 0.0
            )
        }
        .font(.headline)
        .foregroundStyle(showCheckmark ? Color.theme.green : Color.theme.accent)
    }
    
    private func saveButtonPressed() {
        guard let coin = selectedCoin else { return }
        
        // save to portfolio
        
        // show the checkmark
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }
        
        // hide keyboard
        UIApplication.shared.endEditing()
        
        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 , execute: DispatchWorkItem(block: {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }))
    }
    
    // unselect the coin
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
}

#Preview {
    PortfolioView()
        .environment(pd().homeVM)
}