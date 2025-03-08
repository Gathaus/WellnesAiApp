import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @State private var currentMood: MoodType = .neutral
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Üst karşılama kartı
                greetingCard
                
                // Bugünkü ruh hali kartı
                moodSelectionCard
                
                // Günlük pozitif mesaj kartı
                dailyAffirmationCard
                
                // Hızlı erişim kartları
                quickAccessCardsSection
                
                // Ruh hali geçmişi
                moodHistorySection
            }
            .padding(.horizontal)
            .padding(.bottom, 100)
        }
        .background(Color(.systemGray6).ignoresSafeArea())
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
    
    // MARK: - Component Views
    private var greetingCard: some View {
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
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Text("✨")
                    .font(.system(size: 25))
            }
        }
        .padding(.top, 10)
    }
    
    private var moodSelectionCard: some View {
        VStack(spacing: 15) {
            Text("Bugün nasıl hissediyorsun?")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
            
            moodButtonsRow
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    private var moodButtonsRow: some View {
        // Breaking down the complex ForEach into a simpler HStack
        HStack(spacing: 20) {
            moodButton(for: .fantastic)
            moodButton(for: .good)
            moodButton(for: .neutral)
            moodButton(for: .bad)
            moodButton(for: .awful)
        }
    }
    
    private func moodButton(for mood: MoodType) -> some View {
        Button(action: {
            withAnimation {
                currentMood = mood
                viewModel.logMood(mood)
            }
        }) {
            VStack {
                // Extract the emoji display to simplify the button content
                moodEmojiView(for: mood)
                
                Text(mood.rawValue)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(currentMood == mood ? .primary : .secondary)
            }
        }
    }
    
    private func moodEmojiView(for mood: MoodType) -> some View {
        Text(mood.emoji)
            .font(.system(size: 30))
            .shadow(color: .gray.opacity(0.3), radius: 2, x: 1, y: 1)
            .padding(8)
            .background(
                Circle()
                    .fill(moodCircleGradient(for: mood))
                    .frame(width: 60, height: 60)
            )
    }
    
    // Fix for the type mismatch - always return a LinearGradient
    private func moodCircleGradient(for mood: MoodType) -> LinearGradient {
        if currentMood == mood {
            return LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.6), .purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var dailyAffirmationCard: some View {
        VStack(spacing: 20) {
            HStack {
                Text("📝 Günün İlham Sözü")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                
                Spacer()
            }
            
            Text(viewModel.dailyAffirmation)
                .font(.system(size: 20, weight: .medium, design: .serif))
                .italic()
                .multilineTextAlignment(.center)
                .padding(.vertical, 15)
                .lineSpacing(8)
                .foregroundColor(.black.opacity(0.8))
            
            // Sosyal paylaşım butonları
            HStack(spacing: 15) {
                shareButtonView(text: "Kopyala", icon: "doc.on.doc.fill", color: .blue) {
                    UIPasteboard.general.string = viewModel.dailyAffirmation
                }
                
                shareButtonView(text: "Paylaş", icon: "square.and.arrow.up.fill", color: .green) {
                    // Paylaşım işlemleri buraya
                }
            }
        }
        .padding(25)
        .background(
            affirmationCardBackground
        )
    }
    
    private var affirmationCardBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.1)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Arka planda dekoratif elemanlar
            Circle()
                .fill(Color.purple.opacity(0.1))
                .frame(width: 100, height: 100)
                .offset(x: -120, y: -60)
            
            Circle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 60, height: 60)
                .offset(x: 130, y: 70)
        }
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    private func shareButtonView(text: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
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
    
    private var quickAccessCardsSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            // BU BÖLÜMÜ DEĞİŞTİRİYORUM - EnvironmentObject'i doğru aktarmak için
            chatCardView
            meditationCardView
            inspirationCardView
        }
    }
    
    // BU BÖLÜMÜ DEĞİŞTİRİYORUM - NavigationLink yerine doğrudan view döndürüyorum
    private var chatCardView: some View {
        NavigationLink(destination: ChatView().environmentObject(viewModel)) {
            QuickAccessCard(
                icon: "message.fill",
                title: "Sohbet",
                description: "Asistanla konuş",
                color: .blue
            )
        }
    }
    
    private var meditationCardView: some View {
        NavigationLink(destination: MeditationView().environmentObject(viewModel)) {
            QuickAccessCard(
                icon: "lungs.fill",
                title: "Meditasyon",
                description: "İç huzur bul",
                color: .purple
            )
        }
    }
    
    private var inspirationCardView: some View {
        NavigationLink(destination: InspirationView().environmentObject(viewModel)) {
            QuickAccessCard(
                icon: "lightbulb.fill",
                title: "İlham Sözleri",
                description: "Günlük motivasyon",
                color: .orange
            )
        }
    }
    
    private var moodHistorySection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Son 7 Gün - Ruh Hali Takibi")
                .font(.system(size: 18, weight: .bold, design: .rounded))
            
            MoodHistoryChartSimplified(moodHistory: viewModel.moodHistory)
                .frame(height: 200)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
}

// MARK: - Helper Views

struct QuickAccessCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // İkon ve başlık
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.7)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
            }
            
            Text(description)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            Spacer()
            
            // Devam et ikonu
            HStack {
                Spacer()
                
                Image(systemName: "chevron.right.circle.fill")
                    .foregroundColor(color.opacity(0.7))
                    .font(.system(size: 22))
            }
        }
        .padding(15)
        .frame(height: 135)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: color.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}

// Further simplified MoodHistoryChart to avoid complex ForEach
struct MoodHistoryChartSimplified: View {
    let moodHistory: [MoodHistoryEntry]
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 0) {
                if !moodHistory.isEmpty {
                    // Instead of ForEach, use explicit views
                    let columns = min(moodHistory.count, 7)
                    let spacing: CGFloat = 10
                    let availableWidth = geometry.size.width - (spacing * CGFloat(columns - 1))
                    let columnWidth = availableWidth / CGFloat(columns)
                    
                    // Generate column views
                    ForEach(0..<columns, id: \.self) { index in
                        if index < moodHistory.count {
                            let entry = moodHistory[index]
                            MoodColumnView(
                                entry: entry,
                                columnWidth: columnWidth
                            )
                            if index < columns - 1 {
                                Spacer().frame(width: spacing)
                            }
                        }
                    }
                } else {
                    // Empty state
                    Text("Henüz ruh hali verisi yok")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct MoodColumnView: View {
    let entry: MoodHistoryEntry
    let columnWidth: CGFloat
    
    var body: some View {
        VStack {
            Text(entry.mood.emoji)
                .font(.system(size: 20))
                .shadow(color: .gray.opacity(0.3), radius: 1, x: 1, y: 1)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(moodGradient(for: entry.mood))
                .frame(width: columnWidth, height: CGFloat(entry.mood.value) * 25)
            
            Text(formatDate(entry.date))
                .font(.system(size: 10))
                .foregroundColor(.secondary)
        }
    }
    
    private func moodGradient(for mood: MoodType) -> LinearGradient {
        let color = moodColor(mood)
        return LinearGradient(
            gradient: Gradient(colors: [color.opacity(0.7), color]),
            startPoint: .top,
            endPoint: .bottom
        )
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
