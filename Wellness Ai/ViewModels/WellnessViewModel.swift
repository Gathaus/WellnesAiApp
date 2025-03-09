import Foundation
import Combine
import SwiftUI

class WellnessViewModel: ObservableObject {
    // Services
    private let storageService: StorageService
    private let aiService: AIServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // Published properties
    @Published var user: User?
    @Published var messages: [Message] = []
    @Published var wellnessTips: [WellnessTip] = []
    @Published var dailyAffirmation: String = ""
    @Published var currentInput: String = ""
    @Published var moodHistory: [MoodHistoryEntry] = []
    @Published var goals: [Goal] = []
    @Published var isPremium: Bool = false
    
    init(storageService: StorageService = StorageService(), aiService: AIServiceProtocol = AIService()) {
        self.storageService = storageService
        self.aiService = aiService

        loadUserData()
        loadMessages()
        loadMoodHistory()
        loadGoals()
        loadPremiumStatus()

        wellnessTips = aiService.getWellnessTips()
        dailyAffirmation = aiService.getDailyAffirmation()
        
        // If mood history is empty, set up sample data
        if moodHistory.isEmpty {
            setupSampleMoodHistory()
        }
        
        // If goals are empty, set up sample goals
        if goals.isEmpty {
            goals = sampleGoals
        }
    }

    // MARK: - Data Loading Methods
    
    private func loadUserData() {
        user = storageService.loadUser()
    }
    
    private func loadMessages() {
        messages = storageService.loadMessages()
    }
    
    private func loadMoodHistory() {
        moodHistory = storageService.loadMoodHistory()
    }

    private func loadGoals() {
        goals = storageService.loadGoals()
    }

    private func loadPremiumStatus() {
        isPremium = storageService.loadPremiumStatus()
    }

    // MARK: - User Management

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
    
    // MARK: - Messaging

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
    
    // MARK: - Affirmations & Tips

    func refreshDailyAffirmation() {
        dailyAffirmation = aiService.getDailyAffirmation()
    }
    
    func getFilteredTips(for category: TipCategory?) -> [WellnessTip] {
        guard let category = category else { return wellnessTips }
        return wellnessTips.filter { $0.category == category }
    }
    
    // MARK: - Mood Tracking

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
        
        // Mood history'yi kaydet
        storageService.saveMoodHistory(moodHistory)
    }
    
    // Örnek ruh hali verileri oluştur
    private func setupSampleMoodHistory() {
        let calendar = Calendar.current
        let today = Date()
        
        // Son 7 günün ruh hali verilerini oluştur
        moodHistory = (0..<7).map { dayOffset in
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
            let randomMoodIndex = Int.random(in: 0..<MoodType.allCases.count)
            let moodType = MoodType.allCases[randomMoodIndex]
            return MoodHistoryEntry(mood: moodType, date: date)
        }

        // Örnek verileri kaydet
        storageService.saveMoodHistory(moodHistory)
    }
    
    // MARK: - Goals Management

    func addGoal(_ goal: Goal) {
        goals.append(goal)
        storageService.saveGoals(goals)
    }
    
    func updateGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
            storageService.saveGoals(goals)
        }
    }
    
    func deleteGoal(_ goal: Goal) {
        goals.removeAll(where: { $0.id == goal.id })
        storageService.saveGoals(goals)
    }

    func toggleGoalCompletion(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index].isCompleted.toggle()
            storageService.saveGoals(goals)
        }
    }
    
    // MARK: - Premium Management

    func updatePremiumStatus(_ isPremium: Bool) {
        self.isPremium = isPremium
        storageService.savePremiumStatus(isPremium)
    }
    
    // MARK: - Settings Management

    func updateUserSettings(notifications: Bool, darkMode: Bool, reminderTime: Date, languageCode: String) {
        let settings = UserSettings(
            notificationsEnabled: notifications,
            darkModeEnabled: darkMode,
            reminderTime: reminderTime,
            languageCode: languageCode
        )
        storageService.saveSettings(settings)
    }
    
    func loadUserSettings() -> UserSettings {
        return storageService.loadSettings() ?? UserSettings()
    }
    
    // Add this method to WellnessViewModel class

    func saveUser(_ user: User) {
        self.user = user
        storageService.saveUser(user)
    }
}

// MARK: - Sample Data

// Örnek hedefler
let sampleGoals = [
    Goal(title: "Her gün 10 dakika meditasyon", type: .meditation, targetDate: Date().addingTimeInterval(60*60*24*7)),
    Goal(title: "Günde 2 litre su içmek", type: .water, targetDate: nil),
    Goal(title: "Haftada 3 gün egzersiz yapmak", type: .exercise, targetDate: Date().addingTimeInterval(60*60*24*30)),
    Goal(title: "Her gün günlük tutmak", type: .journal, targetDate: nil, isCompleted: true),
    Goal(title: "Farkındalık pratikleri yapmak", type: .mindfulness, targetDate: nil, isCompleted: true)
]

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
