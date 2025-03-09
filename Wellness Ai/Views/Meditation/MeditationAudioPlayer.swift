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
    
    // Embedded sample sounds for meditation
    private let sampleSounds = [
        "meditation_calm": "Calming meditation sound",
        "meditation_focus": "Odaklanma meditasyon sesi",
        "meditation_sleep": "Uyku meditasyon sesi",
        "meditation_anxiety": "Kaygı azaltma meditasyon sesi"
    ]

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

    func loadAudio(for meditationType: MeditationType? = nil) {
        // Select appropriate sound file for meditation type
        let soundName: String
        if let type = meditationType {
            switch type {
            case .focus:
                soundName = "meditation_focus"
            case .sleep:
                soundName = "meditation_sleep"
            case .anxiety:
                soundName = "meditation_anxiety"
            case .calm:
                soundName = "meditation_calm"
            }
        } else {
            soundName = "meditation_calm" // Default sound
        }
        
        // Use synthetic sounds if no real files exist
        if let path = Bundle.main.path(forResource: soundName, ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.numberOfLoops = -1 // Loop indefinitely
                self.duration = audioPlayer?.duration ?? 300
            } catch {
                print("Failed to load audio file: \(error)")
                createSyntheticSound()
            }
        } else {
            // If no real audio file exists, create a synthetic sound
            createSyntheticSound()
        }
    }
    
    private func createSyntheticSound() {
        print("Using synthetic meditation sound instead")
        // Create a synthetic sound using AudioKit or similar
        // For now, we'll just simulate the audio with a timer
        self.duration = 300 // 5 minutes
    }

    func play() {
        if audioPlayer != nil {
            audioPlayer?.play()
        }
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
