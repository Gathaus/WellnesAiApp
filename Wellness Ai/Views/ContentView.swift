import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @State private var selectedTab = 0
    @State private var showSubscribeSheet = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                
                MeditationView()
                    .tag(1)
                
                ChatView()
                    .tag(2)
                
                TipsView()
                    .tag(3)
                
                ProfileView(showSubscribeSheet: $showSubscribeSheet)
                    .tag(4)
            }
            .edgesIgnoringSafeArea(.bottom)
            
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
        TabItem(icon: "list.bullet.clipboard.fill", name: "İpuçları"),
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
                                .fill(selectedTab == index ? Color.accentColor.opacity(0.2) : Color.clear)
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: tabItems[index].icon)
                                .font(.system(size: 22))
                                .foregroundColor(selectedTab == index ? .accentColor : .gray)
                        }
                        
                        Text(tabItems[index].name)
                            .font(.system(size: 10))
                            .foregroundColor(selectedTab == index ? .accentColor : .gray)
                    }
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("TabBarBackground"))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        )
        .padding(.horizontal)
    }
}

struct TabItem {
    let icon: String
    let name: String
}
