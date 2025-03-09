import Foundation
import Combine

class StorageService {
    // Key definitions
    private enum StorageKeys {
        static let userDefaultsKey = "wellnessUser"
        static let messagesKey = "wellnessMessages"
        static let moodHistoryKey = "wellnessMoodHistory"
        static let goalsKey = "wellnessGoals"
        static let settingsKey = "wellnessSettings"
        static let premiumStatusKey = "wellnessPremiumStatus"
        static let trialEndDateKey = "wellnessTrialEndDate"
        static let favoritedInspirationsKey = "wellnessFavoritedInspirations"
    }
    
    // MARK: - User Operations
    
    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: StorageKeys.userDefaultsKey)
        }
    }
    
    func loadUser() -> User? {
        if let userData = UserDefaults.standard.data(forKey: StorageKeys.userDefaultsKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            return user
        }
        return nil
    }
    
    // MARK: - Messages Operations

    func saveMessages(_ messages: [Message]) {
        if let encoded = try? JSONEncoder().encode(messages) {
            UserDefaults.standard.set(encoded, forKey: StorageKeys.messagesKey)
        }
    }
    
    func loadMessages() -> [Message] {
        if let messageData = UserDefaults.standard.data(forKey: StorageKeys.messagesKey),
           let messages = try? JSONDecoder().decode([Message].self, from: messageData) {
            return messages
        }
        return []
    }
    
    // MARK: - Mood History Operations

    func saveMoodHistory(_ moodHistory: [MoodHistoryEntry]) {
        if let encoded = try? JSONEncoder().encode(moodHistory) {
            UserDefaults.standard.set(encoded, forKey: StorageKeys.moodHistoryKey)
        }
    }
    
    func loadMoodHistory() -> [MoodHistoryEntry] {
        if let moodData = UserDefaults.standard.data(forKey: StorageKeys.moodHistoryKey),
           let moodHistory = try? JSONDecoder().decode([MoodHistoryEntry].self, from: moodData) {
            return moodHistory
        }
        return []
    }
    
    // MARK: - Goals Operations

    func saveGoals(_ goals: [Goal]) {
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: StorageKeys.goalsKey)
        }
    }
    
    func loadGoals() -> [Goal] {
        if let goalData = UserDefaults.standard.data(forKey: StorageKeys.goalsKey),
           let goals = try? JSONDecoder().decode([Goal].self, from: goalData) {
            return goals
        }
        return []
    }
    
    // MARK: - Premium Status Operations

    func savePremiumStatus(_ isPremium: Bool) {
        UserDefaults.standard.set(isPremium, forKey: StorageKeys.premiumStatusKey)
    }
    
    func loadPremiumStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: StorageKeys.premiumStatusKey)
    }
    
    // MARK: - Trial Operations
    
    func saveTrialEndDate(_ date: Date) {
        UserDefaults.standard.set(date, forKey: StorageKeys.trialEndDateKey)
    }
    
    func loadTrialEndDate() -> Date? {
        return UserDefaults.standard.object(forKey: StorageKeys.trialEndDateKey) as? Date
    }
    
    // MARK: - Favorited Inspirations Operations
    
    func saveFavoritedInspirations(_ inspirations: [String]) {
        if let encoded = try? JSONEncoder().encode(inspirations) {
            UserDefaults.standard.set(encoded, forKey: StorageKeys.favoritedInspirationsKey)
        }
    }
    
    func loadFavoritedInspirations() -> [String] {
        if let data = UserDefaults.standard.data(forKey: StorageKeys.favoritedInspirationsKey),
           let inspirations = try? JSONDecoder().decode([String].self, from: data) {
            return inspirations
        }
        return []
    }
    
    // MARK: - Settings Operations

    func saveSettings(_ settings: UserSettings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: StorageKeys.settingsKey)
        }
    }
    
    func loadSettings() -> UserSettings? {
        if let settingsData = UserDefaults.standard.data(forKey: StorageKeys.settingsKey),
           let settings = try? JSONDecoder().decode(UserSettings.self, from: settingsData) {
            return settings
        }
        return nil
    }
}
