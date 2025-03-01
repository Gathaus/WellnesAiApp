import Foundation
import SwiftUI

struct Meditation: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let duration: Int // dakika cinsinden
    let type: MeditationType
    let imageName: String
    
    init(id: UUID = UUID(), title: String, description: String, duration: Int, type: MeditationType, imageName: String) {
        self.id = id
        self.title = title
        self.description = description
        self.duration = duration
        self.type = type
        self.imageName = imageName
    }
}

enum MeditationType: String, CaseIterable, Codable {
    case focus = "Odaklanma"
    case sleep = "Uyku"
    case anxiety = "Kaygı"
    case calm = "Sakinlik"
    
    var icon: String {
        switch self {
        case .focus: return "brain"
        case .sleep: return "moon.stars.fill"
        case .anxiety: return "wind"
        case .calm: return "leaf.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .focus: return .blue
        case .sleep: return .purple
        case .anxiety: return .orange
        case .calm: return .green
        }
    }
}
