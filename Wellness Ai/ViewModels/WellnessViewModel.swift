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
    @Published var isInTrialPeriod: Bool = false
    @Published var trialEndDate: Date?
    @Published var favoritedInspirations: [String] = []
    
    init(storageService: StorageService = StorageService(), aiService: AIServiceProtocol = AIService()) {
        self.storageService = storageService
        self.aiService = aiService

        loadUserData()
        loadMessages()
        loadMoodHistory()
        loadGoals()
        loadPremiumStatus()
        loadTrialStatus()
        loadFavoritedInspirations()

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
    
    private func loadTrialStatus() {
        if let endDate = storageService.loadTrialEndDate() {
            trialEndDate = endDate
            
            // Check if trial is still valid
            if Date() < endDate {
                isInTrialPeriod = true
                isPremium = true
            } else {
                // Trial has expired
                isInTrialPeriod = false
                if !storageService.loadPremiumStatus() {
                    isPremium = false
                }
            }
        }
    }
    
    private func loadFavoritedInspirations() {
        favoritedInspirations = storageService.loadFavoritedInspirations()
    }

    // MARK: - User Management

    func createUser(name: String) {
        let newUser = User(name: name)
        user = newUser
        storageService.saveUser(newUser)
        
        // Welcome message
        let welcomeMessage = Message(
            content: "Hello \(name)! I'm your wellness assistant. I'm here whenever you want to share how you're feeling, get motivation, or just chat.",
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
        
        // Generate AI response
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
        
        // Find and update today's entry or add new
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let index = moodHistory.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
            moodHistory[index] = newEntry
        } else {
            // If history is too long, remove oldest entry
            if moodHistory.count >= 7 {
                moodHistory.sort(by: { $0.date > $1.date })
                moodHistory.removeLast()
            }
            moodHistory.append(newEntry)
        }
        
        // Sort history by date
        moodHistory.sort(by: { $0.date > $1.date })
        
        // Save mood history
        storageService.saveMoodHistory(moodHistory)
    }
    
    // Create sample mood data
    private func setupSampleMoodHistory() {
        let calendar = Calendar.current
        let today = Date()
        
        // Create mood data for the last 7 days
        moodHistory = (0..<7).map { dayOffset in
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
            let randomMoodIndex = Int.random(in: 0..<MoodType.allCases.count)
            let moodType = MoodType.allCases[randomMoodIndex]
            return MoodHistoryEntry(mood: moodType, date: date)
        }

        // Save sample data
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
    
    func startFreeTrial() {
        let threeDays: TimeInterval = 3 * 24 * 60 * 60 // 3 days in seconds
        let endDate = Date().addingTimeInterval(threeDays)
        trialEndDate = endDate
        isInTrialPeriod = true
        storageService.saveTrialEndDate(endDate)
        
        // Treat trial users as premium for the duration
        updatePremiumStatus(true)
    }
    
    // MARK: - Favorites Management
    
    func toggleFavoriteInspiration(_ inspiration: String) {
        if favoritedInspirations.contains(inspiration) {
            favoritedInspirations.removeAll { $0 == inspiration }
        } else {
            favoritedInspirations.append(inspiration)
        }
        saveFavoritedInspirations()
    }
    
    func isInspirationFavorited(_ inspiration: String) -> Bool {
        return favoritedInspirations.contains(inspiration)
    }
    
    func saveFavoritedInspirations() {
        storageService.saveFavoritedInspirations(favoritedInspirations)
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
    
    func saveUser(_ user: User) {
        self.user = user
        storageService.saveUser(user)
    }
}

// MARK: - Sample Data

// Sample goals
let sampleGoals = [
    Goal(title: "Meditate for 10 minutes daily", type: .meditation, targetDate: Date().addingTimeInterval(60*60*24*7)),
    Goal(title: "Drink 2 liters of water daily", type: .water, targetDate: nil),
    Goal(title: "Exercise 3 times a week", type: .exercise, targetDate: Date().addingTimeInterval(60*60*24*30)),
    Goal(title: "Keep a daily journal", type: .journal, targetDate: nil, isCompleted: true),
    Goal(title: "Practice mindfulness", type: .mindfulness, targetDate: nil, isCompleted: true)
]

// Sample meditations
let sampleMeditations = [
    Meditation(title: "Morning Focus", description: "A short meditation to start your day with energy", duration: 5, type: .focus, imageName: "sunrise.fill"),
    Meditation(title: "Deep Focus", description: "Concentration-enhancing meditation before work", duration: 10, type: .focus, imageName: "lightbulb.fill"),
    Meditation(title: "Mind Clearing", description: "Reduce mental fatigue with focused meditation", duration: 15, type: .focus, imageName: "cloud.fill"),

    Meditation(title: "Peaceful Sleep", description: "Bedtime meditation for restful sleep", duration: 10, type: .sleep, imageName: "moon.zzz.fill"),
    Meditation(title: "Night Relaxation", description: "Meditation with sounds to help fall asleep", duration: 20, type: .sleep, imageName: "star.fill"),
    Meditation(title: "Deep Sleep", description: "Deep relaxation techniques for quality sleep", duration: 30, type: .sleep, imageName: "bed.double.fill"),

    Meditation(title: "Anxiety Reduction", description: "Breathing techniques for calming anxiety", duration: 8, type: .anxiety, imageName: "waveform.path"),
    Meditation(title: "Let Go of Worry", description: "Guided meditation to reduce mental tension", duration: 12, type: .anxiety, imageName: "arrow.up.heart.fill"),
    Meditation(title: "Emergency Calm", description: "Quick relaxation techniques for panic moments", duration: 5, type: .anxiety, imageName: "lungs.fill"),

    Meditation(title: "Inner Peace", description: "Meditation to help find inner peace", duration: 15, type: .calm, imageName: "leaf.fill"),
    Meditation(title: "Nature Sounds", description: "Calming meditation with nature sounds", duration: 20, type: .calm, imageName: "tree.fill"),
    Meditation(title: "Day Completion", description: "End of day relaxation and gratitude meditation", duration: 10, type: .calm, imageName: "sunset.fill")
]
