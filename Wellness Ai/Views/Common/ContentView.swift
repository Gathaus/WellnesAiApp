import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @State private var selectedTab = 0
    @State private var showSubscribeSheet = false

    var body: some View {
        ZStack(alignment: .bottom) {
            // Ana içerik alanı
            VStack {
                // Seçilen tabın içeriği
                tabContent

                Spacer()
            }

            // Özel tab bar
            CustomTabBar(selectedTab: $selectedTab)
                .padding(.bottom, 8)
        }
        .sheet(isPresented: $showSubscribeSheet) {
            SubscriptionView()
        }
    }

    // MARK: - Tab Content

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case 0:
            HomeView()
                .environmentObject(viewModel)
        case 1:
            MeditationView()
                .environmentObject(viewModel)
        case 2:
            ChatView()
                .environmentObject(viewModel)
        case 3:
            InspirationView()
                .environmentObject(viewModel)
        case 4:
            ProfileView(showSubscribeSheet: $showSubscribeSheet)
                .environmentObject(viewModel)
        default:
            HomeView()
                .environmentObject(viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(WellnessViewModel())
    }
}