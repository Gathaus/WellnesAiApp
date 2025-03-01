import Foundation
import SwiftUI // Bu satırı ekleyin

struct Goal: Identifiable, Codable {
    let id: UUID
    let title: String
    let type: GoalType
    let targetDate: Date?
    var isCompleted: Bool = false
    let createdAt: Date = Date()
    
    init(id: UUID = UUID(), title: String, type: GoalType, targetDate: Date?, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.type = type
        self.targetDate = targetDate
        self.isCompleted = isCompleted
    }
}

// Hedef tipi
enum GoalType: String, CaseIterable, Identifiable, Codable {
    case meditation = "Meditasyon"
    case mindfulness = "Farkındalık"
    case exercise = "Egzersiz"
    case sleep = "Uyku"
    case water = "Su İçme"
    case reading = "Okuma"
    case journal = "Günlük Yazma"
    case gratitude = "Şükran"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .meditation: return "brain.head.profile"
        case .mindfulness: return "leaf.fill"
        case .exercise: return "figure.walk"
        case .sleep: return "moon.stars.fill"
        case .water: return "drop.fill"
        case .reading: return "book.fill"
        case .journal: return "pencil.and.outline"
        case .gratitude: return "heart.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .meditation: return .purple
        case .mindfulness: return .green
        case .exercise: return .orange
        case .sleep: return .blue
        case .water: return .cyan
        case .reading: return .brown
        case .journal: return .indigo
        case .gratitude: return .pink
        }
    }
}
