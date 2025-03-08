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