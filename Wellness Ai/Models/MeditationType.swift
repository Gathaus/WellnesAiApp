import Foundation
import SwiftUI

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