import Foundation
import Combine
import SwiftUI

class WellnessViewModel: ObservableObject {
    private let storageService = StorageService()
    private let aiService = AIService()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var user: User?
    @Published var messages: [Message] = []
    @Published var wellnessTips: [WellnessTip] = []
    @Published var dailyAffirmation: String = ""
    @Published var currentInput: String = ""
    @Published var moodHistory: [MoodHistoryEntry] = [] // Ruh hali geçmişi
    @Published var goals: [Goal] = [] // Hedefler
    @Published var isPremium: Bool = false // Premium durumu
    
    init() {
        loadUserData()
        loadMessages()
        wellnessTips = aiService.getWellnessTips()
        dailyAffirmation = aiService.getDailyAffirmation()
        
        // Örnek ruh hali verileri
        setupSampleMoodHistory()
        
        // Örnek hedefler
        goals = sampleGoals
    }
    
    private func loadUserData() {
        user = storageService.loadUser()
    }
    
    private func loadMessages() {
        messages = storageService.loadMessages()
    }
    
    func createUser(name: String) {
        let newUser = User(name: name)
        user = newUser
        storageService.saveUser(newUser)
        
        // Kullanıcıya hoş geldin mesajı
        let welcomeMessage = Message(
            content: "Merhaba \(name)! Ben senin wellness asistanın. Nasıl hissettiğini paylaşmak, motivasyon almak veya sadece sohbet etmek istediğinde buradayım.",
            isFromUser: false
        )
        messages.append(welcomeMessage)
        storageService.saveMessages(messages)
    }
    
    func sendMessage(_ content: String) {
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = Message(content: content, isFromUser: true)
        messages.append(userMessage)
        storageService.saveMessages(messages)
        currentInput = ""
        
        // AI yanıtı oluştur
        aiService.generateResponse(to: content)
            .receive(on: RunLoop.main)
            .sink { [weak self] response in
                guard let self = self else { return }
                let aiMessage = Message(content: response, isFromUser: false)
                self.messages.append(aiMessage)
                self.storageService.saveMessages(self.messages)
            }
            .store(in: &cancellables)
    }
    
    func refreshDailyAffirmation() {
        dailyAffirmation = aiService.getDailyAffirmation()
    }
    
    func getFilteredTips(for category: TipCategory?) -> [WellnessTip] {
        guard let category = category else { return wellnessTips }
        return wellnessTips.filter { $0.category == category }
    }
    
    // Ruh hali kaydet
        func logMood(_ mood: MoodType) {
            let newEntry = MoodHistoryEntry(mood: mood, date: Date())
            
            // Bugünün girişini bul ve güncelle veya yeni ekle
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            
            if let index = moodHistory.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
                moodHistory[index] = newEntry
            } else {
                // Eğer geçmiş çok uzunsa, en eski girişi kaldır
                if moodHistory.count >= 7 {
                    moodHistory.sort(by: { $0.date > $1.date })
                    moodHistory.removeLast()
                }
                moodHistory.append(newEntry)
            }
            
            // Geçmişi tarihe göre sırala
            moodHistory.sort(by: { $0.date > $1.date })
            
            // Burada verileri saklama kodları eklenebilir
        }
        
        // Örnek ruh hali verileri oluştur
        private func setupSampleMoodHistory() {
            let calendar = Calendar.current
            let today = Date()
            
            // Son 7 günün ruh hali verilerini oluştur
            moodHistory = (0..<7).map { dayOffset in
                let date = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
                let randomMoodIndex = Int.random(in: 0..<MoodType.allCases.count)
                let mood = MoodType.allCases[randomMoodIndex]
                return MoodHistoryEntry(mood: mood, date: date)
            }
        }
        
        // Yeni hedef ekle
        func addGoal(_ goal: Goal) {
            goals.append(goal)
            // Burada hedef saklama kodları eklenebilir
        }
        
        // Hedefi güncelle
        func updateGoal(_ goal: Goal) {
            if let index = goals.firstIndex(where: { $0.id == goal.id }) {
                goals[index] = goal
                // Burada hedef güncelleme kodları eklenebilir
            }
        }
        
        // Hedefi sil
        func deleteGoal(_ goal: Goal) {
            goals.removeAll(where: { $0.id == goal.id })
            // Burada hedef silme kodları eklenebilir
        }
        
        // Premium abonelik durumunu güncelle
        func updatePremiumStatus(_ isPremium: Bool) {
            self.isPremium = isPremium
            // Burada abonelik durumu saklama kodları eklenebilir
        }
        
        // Kullanıcı ayarlarını güncelle
        func updateUserSettings(notifications: Bool, darkMode: Bool) {
            // Burada kullanıcı ayarları güncelleme kodları eklenebilir
        }
        
        // Günlük hatırlatıcı ayarla
        func setDailyReminder(time: Date, enabled: Bool) {
            // Burada bildirim programlama kodları eklenebilir
        }
    }
