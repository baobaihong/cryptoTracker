//
//  SettingsView.swift
//  cryptoTracker
//
//  Created by Jason on 2024/2/26.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultURL = URL(string: "https://www.apple.com")! // NOTICE: don't force unwrap the optional most of the time!!!
    let youtubeURL = URL(string: "https://www.youtube.com")!
    let coffeeURL = URL(string: "https://www.buymeacoffee.com")!
    let coingeckoURL = URL(string: "https://www.coingecko.com")!
    let personalURL = URL(string: "https://www.nicksarno.com")!
    
    var body: some View {
        NavigationStack {
            List {
                aboutAppSection
                coinGeckoSection
                aboutMeSection
            }
            .listStyle(GroupedListStyle())
            .font(.headline)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton()
                }
            }
        }
    }
}

extension SettingsView {
    private var aboutAppSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was an exercise for me following a swift course, using MVVM, Combine and Core data!")
                    .font(.callout)
                    .fontWeight(.regular)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Terms of Service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
        } header: {
            Text("About this App")
        }
        .tint(.blue)
    }
    
    private var coinGeckoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The crypto currency data that is used in this app comes from a free API from CoinGecko! Prices may be slightly delayed")
                    .font(.callout)
                    .fontWeight(.regular)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Visit CoinGecko", destination: coingeckoURL)
        } header: {
            Text("CoinGecko")
        }
        .tint(.blue)
    }
    
    private var aboutMeSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app is developed by Jason. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threading, publishers/subscribers, and data persistence.")
                    .font(.callout)
                    .fontWeight(.regular)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Personal Website", destination: personalURL)
        } header: {
            Text("About me")
        }
        .tint(.blue)
    }
}

#Preview {
    SettingsView()
}
