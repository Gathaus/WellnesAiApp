import Foundation
import SwiftUI

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
