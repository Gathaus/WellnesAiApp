import Foundation

enum TipCategory: String, Codable, CaseIterable, Identifiable {
    case motivation = "Motivation"
    case mindfulness = "Mindfulness"
    case selfCare = "Self Care"
    case positivity = "Positive Thinking"
    
    var id: String { rawValue }
}
