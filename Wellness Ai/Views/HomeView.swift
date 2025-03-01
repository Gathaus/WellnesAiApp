import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @State private var currentMood: MoodType = .neutral
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Üst karşılama kartı
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Merhaba,")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                        
                        if let user = viewModel.user {
                            Text(user.name)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                        }
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(Color.accentColor.opacity(0.1))
                            .frame(width: 50, height: 50)
                        
                        Text("✨")
                            .font(.system(size: 25))
                    }
                }
                .padding(.top, 10)
                
                // Bugünkü ruh hali kartı
                VStack(spacing: 15) {
                    Text("Bugün nasıl hissediyorsun?")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 20) {
                        ForEach(MoodType.allCases, id: \.self) { mood in
                            Button(action: {
                                withAnimation {
                                    currentMood = mood
                                    viewModel.logMood(mood)
                                }
                            }) {
                                VStack {
                                    Text(mood.emoji)
                                        .font(.system(size: 35))
                                        .padding(10)
                                        .background(
                                            Circle()
                                                .fill(currentMood == mood ? Color.accentColor.opacity(0.2) : Color.gray.opacity(0.1))
                                        )
                                    
                                    Text(mood.rawValue)
                                        .font(.system(size: 13, weight: .medium, design: .rounded))
                                        .foregroundColor(currentMood == mood ? .primary : .secondary)
                                }
                            }
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("CardBackground"))
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                )
                
                // Günlük pozitif mesaj kartı
                VStack(spacing: 20) {
                    HStack {
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.yellow)
                        
                        Text("Günün Pozitif Mesajı")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                viewModel.refreshDailyAffirmation()
                            }
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .font(.system(size: 16))
                                .foregroundColor(.blue)
                                .padding(8)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                    
                    Text(viewModel.dailyAffirmation)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 5)
                        .lineSpacing(5)
                    
                    // Sosyal paylaşım butonları
                    HStack(spacing: 15) {
                        ShareButton(text: "Kopyala", icon: "doc.on.doc.fill", color: .blue) {
                            UIPasteboard.general.string = viewModel.dailyAffirmation
                        }
                        
                        ShareButton(text: "Paylaş", icon: "square.and.arrow.up.fill", color: .green) {
                            // Paylaşım işlemleri buraya
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("CardBackground"))
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                )
                
                // Hızlı erişim kartları
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    // Sohbet kartı
                    NavigationLink(destination: ChatView()) {
                        QuickAccessCard(
                            icon: "message.fill",
                            title: "Sohbet",
                            description: "Asistanla konuş",
                            color: .blue
                        )
                    }
                    
                    // Meditasyon kartı
                    NavigationLink(destination: MeditationView()) {
                        QuickAccessCard(
                            icon: "lungs.fill",
                            title: "Meditasyon",
                            description: "İç huzur bul",
                            color: .purple
                        )
                    }
                    
                    // İpuçları kartı
                    NavigationLink(destination: TipsView()) {
                        QuickAccessCard(
                            icon: "lightbulb.fill",
                            title: "İpuçları",
                            description: "Wellness önerileri",
                            color: .orange
                        )
                    }
                    
                    // Hedefler kartı
                    NavigationLink(destination: GoalsView()) {
                        QuickAccessCard(
                            icon: "target",
                            title: "Hedefler",
                            description: "İlerlemeni takip et",
                            color: .red
                        )
                    }
                }
                
                // Ruh hali geçmişi
                VStack(alignment: .leading, spacing: 15) {
                    Text("Son 7 Gün - Ruh Hali Takibi")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                    
                    MoodHistoryChart(moodHistory: viewModel.moodHistory)
                        .frame(height: 200)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("CardBackground"))
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                )
            }
            .padding(.horizontal)
            .padding(.bottom, 100)
        }
        .background(Color("BackgroundColor").ignoresSafeArea())
        .navigationBarTitle("WellnessAI", displayMode: .large)
        .navigationBarItems(trailing:
            Button(action: {
                // Bildirim ayarları
            }) {
                Image(systemName: "bell")
                    .font(.system(size: 18))
                    .foregroundColor(.primary)
            }
        )
    }
}

// Hızlı erişim kartı komponenti
struct QuickAccessCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(.white)
                .padding(12)
                .background(color)
                .clipShape(Circle())
            
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
            
            Text(description)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
        .frame(height: 140)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("CardBackground"))
                .shadow(color: color.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}

// Paylaşım butonu komponenti
struct ShareButton: View {
    let text: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14))
                
                Text(text)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(20)
        }
    }
}

// Ruh hali takip grafiği
struct MoodHistoryChart: View {
    let moodHistory: [MoodHistoryEntry]
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            ForEach(moodHistory) { entry in
                VStack {
                    Text(entry.mood.emoji)
                        .font(.system(size: 20))
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(moodColor(entry.mood))
                        .frame(height: CGFloat(entry.mood.value) * 25)
                    
                    Text(formatDate(entry.date))
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private func moodColor(_ mood: MoodType) -> Color {
        switch mood {
        case .fantastic: return .green
        case .good: return .blue
        case .neutral: return .yellow
        case .bad: return .orange
        case .awful: return .red
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        return formatter.string(from: date)
    }
}

// Ruh hali türleri
enum MoodType: String, CaseIterable {
    case fantastic = "Harika"
    case good = "İyi"
    case neutral = "Normal"
    case bad = "Kötü"
    case awful = "Berbat"
    
    var emoji: String {
        switch self {
        case .fantastic: return "😁"
        case .good: return "🙂"
        case .neutral: return "😐"
        case .bad: return "😕"
        case .awful: return "😢"
        }
    }
    
    var value: Int {
        switch self {
        case .fantastic: return 5
        case .good: return 4
        case .neutral: return 3
        case .bad: return 2
        case .awful: return 1
        }
    }
}

// Ruh hali geçmişi girdisi
struct MoodHistoryEntry: Identifiable {
    let id = UUID()
    let mood: MoodType
    let date: Date
}
