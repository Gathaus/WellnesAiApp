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