import SwiftUI

struct MeditationView: View {
    @State private var selectedCategory: MeditationType = .focus
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Üst başlık
            VStack(alignment: .leading, spacing: 5) {
                Text("Meditasyon")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                
                Text("İç huzuru keşfet")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            // Kategori seçim alanı
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(MeditationType.allCases, id: \.self) { type in
                        Button(action: {
                            withAnimation {
                                selectedCategory = type
                            }
                        }) {
                            VStack {
                                Image(systemName: type.icon)
                                    .font(.system(size: 24))
                                    .foregroundColor(selectedCategory == type ? .white : .primary)
                                    .frame(width: 60, height: 60)
                                    .background(
                                        Circle()
                                            .fill(selectedCategory == type ? type.color : Color("InputBackground"))
                                    )
                                
                                Text(type.rawValue)
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .foregroundColor(selectedCategory == type ? type.color : .primary)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 10)
            
            // Önerilen meditasyonlar
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Önerilen Meditasyonlar")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(meditationsForType(selectedCategory).prefix(3)) { meditation in
                                MeditationCard(meditation: meditation)
                                    .frame(width: 280, height: 200)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Text("Tüm Meditasyonlar")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    ForEach(meditationsForType(selectedCategory)) { meditation in
                        MeditationListItem(meditation: meditation)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                        .frame(height: 100)
                }
            }
            .background(Color("BackgroundColor"))
        }
        .background(Color("BackgroundColor").ignoresSafeArea())
        .navigationTitle("Meditasyon")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func meditationsForType(_ type: MeditationType) -> [Meditation] {
        return sampleMeditations.filter { $0.type == type }
    }
}

// Meditation type enum
enum MeditationType: String, CaseIterable {
    case focus = "Odaklanma"
    case sleep = "Uyku"
    case anxiety = "Kaygı"
    case calm = "Sakinlik"
    
    var icon: String {
        switch self {
        case .focus: return "brain"
        case .sleep: return "moon.stars.fill"
        case .anxiety: return "wind"
        case .calm: return "leaf.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .focus: return .blue
        case .sleep: return .purple
        case .anxiety: return .orange
        case .calm: return .green
        }
    }
}


// Örnek meditasyonlar
let sampleMeditations = [
    Meditation(title: "Sabah Odaklanma", description: "Güne enerjik başlamak için kısa bir meditasyon", duration: 5, type: .focus, imageName: "sunrise.fill"),
    Meditation(title: "Derin Odak", description: "Çalışma öncesi konsantrasyonu artıran meditasyon", duration: 10, type: .focus, imageName: "lightbulb.fill"),
    Meditation(title: "Zihin Temizleme", description: "Zihinsel yorgunluğu azaltan odaklanma meditasyonu", duration: 15, type: .focus, imageName: "cloud.fill"),
    
    Meditation(title: "Huzurlu Uyku", description: "Rahat bir uyku için yatmadan önce yapılacak meditasyon", duration: 10, type: .sleep, imageName: "moon.zzz.fill"),
    Meditation(title: "Gece Rahatlaması", description: "Uykuya dalmayı kolaylaştıran seslerle meditasyon", duration: 20, type: .sleep, imageName: "star.fill"),
    Meditation(title: "Derin Uyku", description: "Kaliteli uyku için derin rahatlama teknikleri", duration: 30, type: .sleep, imageName: "bed.double.fill"),
    
    Meditation(title: "Anksiyete Azaltma", description: "Kaygı durumlarında sakinleşmek için nefes teknikleri", duration: 8, type: .anxiety, imageName: "waveform.path"),
    Meditation(title: "Endişeyi Bırakma", description: "Zihinsel gerginliği azaltan rehberli meditasyon", duration: 12, type: .anxiety, imageName: "arrow.up.heart.fill"),
    Meditation(title: "Acil Sakinleşme", description: "Panik anlarında hızlı rahatlama için teknikler", duration: 5, type: .anxiety, imageName: "lungs.fill"),
    
    Meditation(title: "İç Huzur", description: "İç huzuru bulmanıza yardımcı olan meditasyon", duration: 15, type: .calm, imageName: "leaf.fill"),
    Meditation(title: "Doğa Sesleri", description: "Doğa sesleri eşliğinde sakinleştirici meditasyon", duration: 20, type: .calm, imageName: "tree.fill"),
    Meditation(title: "Günü Tamamlama", description: "Gün sonunda rahatlama ve şükran meditasyonu", duration: 10, type: .calm, imageName: "sunset.fill")
]

// Meditation Card View
struct MeditationCard: View {
    let meditation: Meditation
    
    var body: some View {
        NavigationLink(destination: MeditationDetailView(meditation: meditation)) {
            ZStack(alignment: .bottom) {
                // Arka plan
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [meditation.type.color.opacity(0.7), meditation.type.color]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // İkon
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Spacer()
                        
                        Image(systemName: meditation.imageName)
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.3))
                            .padding(.trailing, 20)
                            .padding(.top, 20)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(meditation.title)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("\(meditation.duration) dakika")
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(meditation.description)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                            .lineLimit(2)
                    }
                    .padding()
                }
            }
        }
    }
}

// Meditation List Item
struct MeditationListItem: View {
    let meditation: Meditation
    
    var body: some View {
        NavigationLink(destination: MeditationDetailView(meditation: meditation)) {
            HStack(spacing: 15) {
                // İkon
                ZStack {
                    Circle()
                        .fill(meditation.type.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: meditation.imageName)
                        .font(.system(size: 22))
                        .foregroundColor(meditation.type.color)
                }
                
                // İçerik
                VStack(alignment: .leading, spacing: 5) {
                    Text(meditation.title)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                    
                    Text(meditation.description)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Süre
                VStack(alignment: .trailing) {
                    Text("\(meditation.duration) dk")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(meditation.type.color)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color("CardBackground"))
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
        }
    }
}

// Meditation Detail View
struct MeditationDetailView: View {
    let meditation: Meditation
    @State private var isPlaying = false
    @State private var progress: Float = 0.0
    @State private var remainingTime = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Üst kısım - Görsel ve başlık
                ZStack(alignment: .bottom) {
                    // Arka plan
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [meditation.type.color.opacity(0.7), meditation.type.color]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 250)
                    
                    // İkon
                    VStack {
                        Image(systemName: meditation.imageName)
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                            .padding(.bottom, 30)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        
                        Text(meditation.title)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.bottom, 20)
                    }
                }
                .edgesIgnoringSafeArea(.top)
                
                // Meditasyon bilgileri
                VStack(alignment: .leading, spacing: 15) {
                    HStack(spacing: 20) {
                        InfoItem(icon: "clock.fill", text: "\(meditation.duration) Dakika")
                        InfoItem(icon: meditation.type.icon, text: meditation.type.rawValue)
                    }
                    
                    Text("Hakkında")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .padding(.top, 5)
                    
                    Text(meditation.description)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .lineSpacing(5)
                    
                    // Oynatma kontrolü
                    VStack(spacing: 15) {
                        // İlerleme çubuğu
                        ProgressBar(value: $progress)
                            .frame(height: 6)
                            .padding(.top, 10)
                        
                        // Zaman göstergesi
                        HStack {
                            Text(formatTime(Int(Float(meditation.duration * 60) * progress)))
                                .font(.system(size: 14, design: .monospaced))
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(remainingTime)
                                .font(.system(size: 14, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                        
                        // Playback kontrolleri
                        HStack(spacing: 30) {
                            Spacer()
                            
                            Button(action: {
                                // 15 saniye geri
                            }) {
                                Image(systemName: "gobackward.15")
                                    .font(.system(size: 30))
                                    .foregroundColor(.primary)
                            }
                            
                            Button(action: {
                                isPlaying.toggle()
                                simulatePlayback()
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(meditation.type.color)
                                        .frame(width: 70, height: 70)
                                    
                                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            Button(action: {
                                // 15 saniye ileri
                            }) {
                                Image(systemName: "goforward.15")
                                    .font(.system(size: 30))
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 20)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            remainingTime = formatTime(meditation.duration * 60)
        }
    }
    
    private func simulatePlayback() {
        // Gerçek bir meditasyon uygulamasında burada ses oynatma kodları olacaktır
        // Şu anda sadece ilerleme simülasyonu yapıyoruz
        if isPlaying {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if self.progress < 1.0 && self.isPlaying {
                    self.progress += 1.0 / Float(self.meditation.duration * 60)
                    let remainingSeconds = Int(Float(self.meditation.duration * 60) * (1 - self.progress))
                    self.remainingTime = formatTime(remainingSeconds)
                } else {
                    timer.invalidate()
                    if self.progress >= 1.0 {
                        self.isPlaying = false
                    }
                }
            }
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}

// Info Item Component
struct InfoItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.accentColor)
            
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(Color("InputBackground"))
        .cornerRadius(10)
    }
}

// Custom Progress Bar
struct ProgressBar: View {
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Arkaplan
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                
                // Değer çubuğu
                Rectangle()
                    .fill(Color.accentColor)
                    .frame(width: CGFloat(value) * geometry.size.width)
                    .cornerRadius(5)
            }
        }
    }
}
