import Foundation
import Combine

protocol AIServiceProtocol {
    func generateResponse(to message: String) -> AnyPublisher<String, Never>
    func getWellnessTips() -> [WellnessTip]
    func getDailyAffirmation() -> String
    func getPersonalizedRecommendation(based on: MoodType) -> String
    func getGoalSuggestions() -> [String]
}