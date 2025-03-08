//
//  Wellness_AiApp.swift
//  Wellness Ai
//
//  Created by Rıza Mert Yağcı on 28.02.2025.
//

import SwiftUI

@main
struct Wellness_AiApp: App {
    @StateObject private var viewModel = WellnessViewModel()
        @AppStorage("isDarkMode") private var isDarkMoede = false
        
        var body: some Scene {
            WindowGroup {
                if viewModel.user == nil {
                    OnboardingView()
                        .environmentObject(viewModel)
                        .preferredColorScheme(isDarkMode ? .dark : .light)
                } else {
                    NavigationView {
                        ContentView()
                            .environmentObject(viewModel)
                            .preferredColorScheme(isDarkMode ? .dark : .light)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .accentColor(Color("AccentColor"))
                }
            }
        }
}
