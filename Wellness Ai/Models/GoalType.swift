import Foundation
import SwiftUI

enum GoalType: String, CaseIterable, Codable, Identifiable {
    case meditation = "Meditation"
    case exercise = "Exercise"
    case water = "Water Intake"
    case journal = "Journaling"
    case mindfulness = "Mindfulness"

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
