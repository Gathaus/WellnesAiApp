import SwiftUI

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
            audioPlayer.loadAudio(for: meditation.type)
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

struct MeditationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationDetailView(
            meditation: Meditation(
                title: "Derin Odak",
                description: "Çalışma öncesi konsantrasyonu artıran meditasyon",
                duration: 10,
                type: .focus,
                imageName: "lightbulb.fill"
            )
        )
    }
}
