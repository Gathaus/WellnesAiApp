import SwiftUI

@main
struct Wellness_AiApp: App {
    @StateObject private var viewModel = WellnessViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("hasSeenSubscription") private var hasSeenSubscription = false

    var body: some Scene {
        WindowGroup {
            if !hasSeenSubscription {
                // Show subscription screen first
                InitialSubscriptionView()
                    .environmentObject(viewModel)
                    .preferredColorScheme(isDarkMode ? .dark : .light)
            } else if viewModel.user == nil {
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
