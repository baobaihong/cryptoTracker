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
    
    // change the navigation title's color to match the color theme
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
    }
    
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
