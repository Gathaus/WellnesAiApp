import Foundation

enum TipCategory: String, Codable, CaseIterable, Identifiable {
    case motivation = "Motivasyon"
    case mindfulness = "Farkındalık"
    case selfCare = "Öz Bakım"
    case positivity = "Pozitif Düşünce"
    
    var id: String { rawValue }
}
