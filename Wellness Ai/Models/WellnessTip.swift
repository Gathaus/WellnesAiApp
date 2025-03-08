import Foundation

struct WellnessTip: Identifiable, Codable, Hashable {
    let id: UUID
    let content: String
    let category: TipCategory
    let createdAt: Date
    
    init(id: UUID = UUID(), content: String, category: TipCategory, createdAt: Date = Date()) {
        self.id = id
        self.content = content
        self.category = category
        self.createdAt = createdAt
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: WellnessTip, rhs: WellnessTip) -> Bool {
        lhs.id == rhs.id
    }
}