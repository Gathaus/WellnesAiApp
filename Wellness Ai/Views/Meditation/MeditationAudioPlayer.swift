import Foundation
import AVFoundation
import Combine

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