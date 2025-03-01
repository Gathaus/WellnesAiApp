import SwiftUI
import AVFoundation

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

struct MeditationView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @State private var selectedCategory: MeditationType = .focus
    
    var body: some View {
        VStack(spacing: 0) {
            // Başlık kısmı
            headerView
            
            // Kategori seçici
            CategorySelectorView(selectedCategory: $selectedCategory)
            
            // Meditasyon listesi
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    // Önerilen meditasyonlar
                    featuredMeditationsSection
                    
                    // Tüm meditasyonlar
                    allMeditationsSection
                    
                    Spacer()
                        .frame(height: 100)
                }
            }
            .background(Color(.systemGray6))
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
    
    // MARK: - UI Bileşenleri
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Meditasyon")
                .font(.system(size: 28, weight: .bold, design: .rounded))
            
            Text("İç huzuru keşfet")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
    }
    
    private var featuredMeditationsSection: some View {
        VStack(alignment: .leading) {
            Text("Önerilen Meditasyonlar")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(.horizontal)
                .padding(.top, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(filteredMeditations.prefix(3)) { meditation in
                        MeditationCard(meditation: meditation)
                            .frame(width: 280, height: 180)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var allMeditationsSection: some View {
        VStack(alignment: .leading) {
            Text("Tüm Meditasyonlar")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(.horizontal)
                .padding(.top, 20)
            
            ForEach(filteredMeditations) { meditation in
                MeditationListItem(meditation: meditation)
                    .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Yardımcı Metotlar
    
    private var filteredMeditations: [Meditation] {
        return sampleMeditations.filter { $0.type == selectedCategory }
    }
}

// MARK: - Kategori Seçici Bileşeni

struct CategorySelectorView: View {
    @Binding var selectedCategory: MeditationType
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(MeditationType.allCases, id: \.self) { type in
                    CategoryButton(
                        type: type,
                        isSelected: selectedCategory == type,
                        action: {
                            withAnimation {
                                selectedCategory = type
                            }
                        }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
}


// MARK: - Meditasyon Kartı Bileşenleri

struct MeditationCard: View {
    let meditation: Meditation
    
    var body: some View {
        NavigationLink(destination: MeditationDetailView(meditation: meditation)) {
            ZStack(alignment: .bottom) {
                // Arka plan
                RoundedRectangle(cornerRadius: 20)
                    .fill(cardGradient)
                    .shadow(color: meditation.type.color.opacity(0.3), radius: 10, x: 0, y: 5)
                
                // İçerik
                cardContent
            }
        }
    }
    
    private var cardGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [meditation.type.color.opacity(0.8), meditation.type.color]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Üst kısım - ikon ve süre
            HStack {
                Image(systemName: meditation.imageName)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
                
                Spacer()
                
                Text("\(meditation.duration) dakika")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(15)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            Spacer()
            
            // Alt kısım - başlık ve açıklama
            VStack(alignment: .leading, spacing: 5) {
                Text(meditation.title)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(meditation.description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(2)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

struct MeditationListItem: View {
    let meditation: Meditation
    
    var body: some View {
        NavigationLink(destination: MeditationDetailView(meditation: meditation)) {
            HStack(spacing: 15) {
                // İkon
                typeIconView
                
                // İçerik
                contentView
                
                Spacer()
                
                // Süre
                durationView
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
        }
    }
    
    private var typeIconView: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [meditation.type.color.opacity(0.8), meditation.type.color]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 50, height: 50)
                .shadow(color: meditation.type.color.opacity(0.2), radius: 5, x: 0, y: 3)
            
            Image(systemName: meditation.imageName)
                .font(.system(size: 22))
                .foregroundColor(.white)
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(meditation.title)
                .font(.system(size: 16, weight: .medium, design: .rounded))
            
            Text(meditation.description)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
    }
    
    private var durationView: some View {
        Text("\(meditation.duration) dk")
            .font(.system(size: 14, weight: .medium, design: .rounded))
            .foregroundColor(meditation.type.color)
    }
}

// MARK: - Meditasyon Detay Görünümü

class MeditationAudioPlayer: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var progress: Float = 0.0
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    
    private var timer: Timer?
    
    init() {
        setupAudioSession()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session setup failed: \(error)")
        }
    }
    
    func loadAudio() {
        // Örnek ses dosyası - gerçek projede bundle'dan yüklenecek
        guard let url = Bundle.main.url(forResource: "meditation_sound", withExtension: "mp3") else {
            // Eğer gerçek ses dosyası yoksa, simüle edelim
            self.duration = 300 // 5 dakika simülasyon
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            self.duration = audioPlayer?.duration ?? 300
        } catch {
            print("Audio player setup failed: \(error)")
        }
    }
    
    func play() {
        if audioPlayer == nil {
            // Simüle edilmiş ses için timer kullanımı
            simulatePlayback()
            return
        }
        
        audioPlayer?.play()
        isPlaying = true
        startTimer()
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        timer?.invalidate()
    }
    
    func seek(to time: TimeInterval) {
        currentTime = time
        progress = Float(currentTime / duration)
        
        if audioPlayer != nil {
            audioPlayer?.currentTime = time
        }
    }
    
    func forward15() {
        let newTime = min(currentTime + 15, duration)
        seek(to: newTime)
    }
    
    func backward15() {
        let newTime = max(currentTime - 15, 0)
        seek(to: newTime)
    }
    
    private func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if let player = self.audioPlayer {
                self.currentTime = player.currentTime
                self.progress = Float(self.currentTime / self.duration)
                
                if !player.isPlaying {
                    self.isPlaying = false
                    self.timer?.invalidate()
                }
            } else {
                // Simülasyon durumunda zaman ilerletme
                if self.isPlaying {
                    self.updateSimulatedTime()
                }
            }
        }
    }
    
    // Ses dosyası yoksa oynatma simülasyonu
    private func simulatePlayback() {
        isPlaying = true
        startTimer()
    }
    
    private func updateSimulatedTime() {
        let newTime = min(currentTime + 0.5, duration)
        currentTime = newTime
        progress = Float(currentTime / duration)
        
        if currentTime >= duration {
            isPlaying = false
            timer?.invalidate()
        }
    }
}

struct MeditationDetailView: View {
    let meditation: Meditation
    @StateObject private var audioPlayer = MeditationAudioPlayer()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .top) {
            // Arkaplan
            meditation.type.color.opacity(0.1)
                .ignoresSafeArea()
            
            // İçerik
            ScrollView {
                VStack(spacing: 25) {
                    // Başlık
                    headerSection
                    
                    // Açıklama
                    descriptionSection
                    
                    // Oynatma kontrolleri
                    playbackControls
                }
            }
            
            // Üst navigasyon çubuğu
            navigationBar
        }
        .navigationBarHidden(true)
        .onAppear {
            audioPlayer.loadAudio()
        }
        .onDisappear {
            audioPlayer.pause()
        }
    }
    
    // MARK: - UI Bileşenleri
    
    private var headerSection: some View {
        VStack(spacing: 15) {
            // Görsel
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [meditation.type.color.opacity(0.7), meditation.type.color]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 150, height: 150)
                    .shadow(color: meditation.type.color.opacity(0.3), radius: 15, x: 0, y: 10)
                
                Image(systemName: meditation.imageName)
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .offset(y: audioPlayer.isPlaying ? -5 : 0)
                    .animation(
                        audioPlayer.isPlaying ?
                        Animation.easeInOut(duration: 1).repeatForever(autoreverses: true) :
                        .default,
                        value: audioPlayer.isPlaying
                    )
            }
            
            // Başlık
            Text(meditation.title)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
            
            // Süre
            Text("\(meditation.duration) dakika • \(meditation.type.rawValue)")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
        .padding(.top, 40)
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Hakkında")
                .font(.system(size: 18, weight: .bold, design: .rounded))
            
            Text(meditation.description)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .lineSpacing(5)
        }
        .padding(.horizontal, 25)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var playbackControls: some View {
        VStack(spacing: 20) {
            // İlerleme göstergesi
            VStack(spacing: 8) {
                // Slider
                Slider(value: Binding(
                    get: { audioPlayer.progress },
                    set: { value in
                        audioPlayer.seek(to: Double(value) * audioPlayer.duration)
                    }
                ), in: 0...1, step: 0.01)
                .accentColor(meditation.type.color)
                
                // Zaman göstergesi
                HStack {
                    Text(formatTime(audioPlayer.currentTime))
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(formatTime(audioPlayer.duration - audioPlayer.currentTime))
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 25)
            
            // Kontrol butonları
            HStack(spacing: 30) {
                // Geri sarma
                backwardButton
                
                // Oynat/Duraklat
                playPauseButton
                
                // İleri sarma
                forwardButton
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 50)
    }
    
    private var backwardButton: some View {
        Button(action: {
            audioPlayer.backward15()
        }) {
            ZStack {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "gobackward.15")
                    .font(.system(size: 24))
                    .foregroundColor(.primary)
            }
        }
    }
    
    private var playPauseButton: some View {
        Button(action: {
            if audioPlayer.isPlaying {
                audioPlayer.pause()
            } else {
                audioPlayer.play()
            }
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [meditation.type.color, meditation.type.color.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: meditation.type.color.opacity(0.3), radius: 10, x: 0, y: 5)
                
                Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
        }
    }
    
    private var forwardButton: some View {
        Button(action: {
            audioPlayer.forward15()
        }) {
            ZStack {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "goforward.15")
                    .font(.system(size: 24))
                    .foregroundColor(.primary)
            }
        }
    }
    
    private var navigationBar: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.primary)
                    .padding(10)
                    .background(Color.white.opacity(0.9))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Button(action: {
                // Favorilere ekle
            }) {
                Image(systemName: "heart")
                    .font(.system(size: 22))
                    .foregroundColor(.primary)
                    .padding(10)
                    .background(Color.white.opacity(0.9))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    // MARK: - Yardımcı Metotlar
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}

// MARK: - İlerleme Çubuğu Bileşeni

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
                    .fill(Color.blue)
                    .frame(width: CGFloat(value) * geometry.size.width)
                    .cornerRadius(5)
            }
        }
    }
}
