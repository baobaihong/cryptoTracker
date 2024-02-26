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
    @State private var showLaunchView: Bool = true
    
    // change the navigation title's color to match the color theme
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack {
                    HomeView()
                        .toolbar(.hidden)
                }
                .environment(vm)
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.opacity.animation(.default))
                    }
                }
                .zIndex(2.0)
            }
            
        }
    }
}
