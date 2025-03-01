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
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Text("✨")
                            .font(.system(size: 25))
                    }
                }
                .padding(.top, 10)
                
                // Bugünkü ruh hali kartı - Emojileri daha görünür hale getirdik
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
                                        .font(.system(size: 42))  // Emoji boyutunu artırdık
                                        .shadow(color: .gray.opacity(0.3), radius: 2, x: 1, y: 1)  // Hafif gölge ekledik
                                        .padding(8)
                                        .background(
                                            Circle()
                                                .fill(currentMood == mood ?
                                                      LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.6), .purple.opacity(0.6)]),
                                                                     startPoint: .topLeading,
                                                                     endPoint: .bottomTrailing)
                                                      : Color.gray.opacity(0.1))
                                                .frame(width: 75, height: 75)
                                        )
                                    
                                    Text(mood.rawValue)
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(currentMood == mood ? .primary : .secondary)
                                }
                            }
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                )
                
                // Günlük pozitif mesaj kartı - Daha anlamlı tasarım
                VStack(spacing: 20) {
                    HStack {
                        Text("📝 Günün İlham Sözü")  // İsim değişikliği
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        
                        Spacer()
                    }
                    
                    Text(viewModel.dailyAffirmation)
                        .font(.system(size: 20, weight: .medium, design: .serif))  // Yazı tipini değiştirdik
                        .italic()  // İtalik yaptık
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 15)
                        .lineSpacing(8)
                        .foregroundColor(.black.opacity(0.8))
                    
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
                .padding(25)
                .background(
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
                )
                
                // Hızlı erişim kartları - Moderni tasarım
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
                    
                    // İlham kartı (İpuçları yerine)
                    NavigationLink(destination: InspirationView()) {
                        QuickAccessCard(
                            icon: "lightbulb.fill",
                            title: "İlham Sözleri",  // İpuçları yerine İlham Sözleri
                            description: "Günlük motivasyon",
                            color: .orange
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
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                )
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
}

// Hızlı erişim kartı komponenti - Modern tasarım
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
                        .shadow(color: .gray.opacity(0.3), radius: 1, x: 1, y: 1)  // Hafif gölge ekledik
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [moodColor(entry.mood).opacity(0.7), moodColor(entry.mood)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
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
