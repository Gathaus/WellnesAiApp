import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @State private var selectedTab = 0
    @State private var showSubscribeSheet = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Ana içerik alanı
            VStack {
                // Seçilen tabın içeriği - Burayı düzenliyorum
                if selectedTab == 0 {
                    HomeView()
                        .environmentObject(viewModel)
                } else if selectedTab == 1 {
                    MeditationView()
                        .environmentObject(viewModel)
                } else if selectedTab == 2 {
                    ChatView()
                        .environmentObject(viewModel)
                } else if selectedTab == 3 {
                    InspirationView()
                        .environmentObject(viewModel)
                } else {
                    ProfileView(showSubscribeSheet: $showSubscribeSheet)
                        .environmentObject(viewModel)
                }
                
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
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let tabItems = [
        TabItem(icon: "house.fill", name: "Ana Sayfa"),
        TabItem(icon: "lungs.fill", name: "Meditasyon"),
        TabItem(icon: "message.fill", name: "Sohbet"),
        TabItem(icon: "lightbulb.fill", name: "İlham"),
        TabItem(icon: "person.fill", name: "Profil")
    ]
    
    var body: some View {
        HStack {
            ForEach(0..<tabItems.count, id: \.self) { index in
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 4) {
                        ZStack {
                            Circle()
                                .fill(selectedTab == index ? Color.blue.opacity(0.2) : Color.clear)
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: tabItems[index].icon)
                                .font(.system(size: 22))
                                .foregroundColor(selectedTab == index ? .blue : .gray)
                        }
                        
                        Text(tabItems[index].name)
                            .font(.system(size: 10))
                            .foregroundColor(selectedTab == index ? .blue : .gray)
                    }
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        )
        .padding(.horizontal)
    }
}

struct TabItem {
    let icon: String
    let name: String
}
