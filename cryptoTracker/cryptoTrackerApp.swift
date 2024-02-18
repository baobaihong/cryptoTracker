//
//  cryptoTrackerApp.swift
//  cryptoTracker
//
//  Created by Jason on 2024/2/17.
//

import SwiftUI

@main
struct cryptoTrackerApp: App {
    @State private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .toolbar(.hidden)
            }
            .environment(vm)
        }
    }
}
