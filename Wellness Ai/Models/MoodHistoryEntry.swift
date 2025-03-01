import Foundation
import SwiftUI

struct MoodHistoryEntry: Identifiable, Codable {
    let id: UUID
    let mood: MoodType
    let date: Date
    
    init(id: UUID = UUID(), mood: MoodType, date: Date) {
        self.id = id
        self.mood = mood
        self.date = date
    }
}

// Ruh hali türleri
enum MoodType: String, CaseIterable, Codable {
    case fantastic = "Harika"
    case good = "İyi"
    case neutral = "Normal"
    case bad = "Kötü"
    case awful = "Berbat"
    
    var emoji: String {
        switch self {
        case .fantastic: return "😁"
        case .good: return "🙂"
        case .neutral: return "😐"
        case .bad: return "😕"
        case .awful: return "😢"
        }
    }
    
    var value: Int {
        switch self {
        case .fantastic: return 5
        case .good: return 4
        case .neutral: return 3
        case .bad: return 2
        case .awful: return 1
        }
    }
}
