import Foundation
import SwiftUI

enum GoalType: String, CaseIterable, Codable, Identifiable {
    case meditation = "Meditasyon"
    case exercise = "Egzersiz"
    case water = "Su İçme"
    case journal = "Günlük"
    case mindfulness = "Farkındalık"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .meditation: return "lungs.fill"
        case .exercise: return "figure.walk"
        case .water: return "drop.fill"
        case .journal: return "book.fill"
        case .mindfulness: return "brain.head.profile"
        }
    }

    var color: Color {
        switch self {
        case .meditation: return .blue
        case .exercise: return .green
        case .water: return .cyan
        case .journal: return .purple
        case .mindfulness: return .orange
        }
    }
}