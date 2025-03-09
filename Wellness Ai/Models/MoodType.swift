import Foundation
import SwiftUI

enum MoodType: String, CaseIterable, Codable {
    case fantastic = "Fantastic"
    case good = "Good"
    case neutral = "Neutral"
    case bad = "Bad"
    case awful = "Awful"

    var emoji: String {
        switch self {
        case .fantastic: return "😁"
        case .good: return "😊"
        case .neutral: return "😐"
        case .bad: return "😔"
        case .awful: return "😩"
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
