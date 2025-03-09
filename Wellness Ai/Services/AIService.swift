import Foundation
import Combine
import SwiftUI

class AIService: AIServiceProtocol {
    private let apiKey = "sk-8e2f3d2238584708854323289ce110e1"
    private let apiUrl = "https://api.deepsek.ai/v1/chat/completions"
    
    func generateResponse(to message: String) -> AnyPublisher<String, Never> {
        // Create URL
        guard let url = URL(string: apiUrl) else {
            return Just("Sorry, I couldn't connect to the assistant.").eraseToAnyPublisher()
        }
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the system prompt for the wellness assistant
        let systemPrompt = """
        You are a supportive wellness assistant helping people improve their mental and emotional wellbeing.
        Always be empathetic, positive, and provide practical advice.
        Focus on helping the user feel better, manage stress, improve sleep, practice mindfulness, and develop healthy habits.
        Keep responses concise and friendly. Your goal is to make the user feel heard, supported, and motivated to take positive steps.
        """
        
        // Create the request body
        let requestBody: [String: Any] = [
            "model": "deepseek-chat",  // Using DeepSek's chat model
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": message]
            ],
            "temperature": 0.7
        ]
        
        // Serialize the request body
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            return Just("Sorry, there was an error preparing your request.").eraseToAnyPublisher()
        }
        
        // Make the request
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map { data, response -> String in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    return "Sorry, I'm having trouble responding right now."
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let choices = json["choices"] as? [[String: Any]],
                       let firstChoice = choices.first,
                       let message = firstChoice["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        return content
                    }
                } catch {
                    print("Error parsing response: \(error)")
                }
                
                return "I'm not sure how to respond to that right now."
            }
            .catch { error -> Just<String> in
                print("Network error: \(error)")
                return Just("Sorry, there was a network error. Please try again later.")
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func getWellnessTips() -> [WellnessTip] {
        // We'll fetch these from backend, but include defaults as fallback
        return [
            WellnessTip(content: "Focus on one goal every day. Small steps lead to big results.", category: .motivation),
            WellnessTip(content: "Try to meditate for at least 10 minutes every day.", category: .mindfulness),
            WellnessTip(content: "Be kind to yourself, focus on progress rather than seeking perfection.", category: .selfCare),
            WellnessTip(content: "Be grateful for three things you do every day.", category: .positivity)
        ]
    }
    
    func getDailyAffirmation() -> String {
        // We'll fetch this from backend, but include a default
        return "Today will be a great day!"
    }

    func getPersonalizedRecommendation(based on: MoodType) -> String {
        switch on {
        case .fantastic:
            return "Note this great feeling. You can use this to create more of these moments."
        case .good:
            return "On this good day, give yourself a small reward or do an activity you enjoy."
        case .neutral:
            return "A short walk or breathing exercise could lift your mood."
        case .bad:
            return "A short meditation or deep breathing exercise could help calm your mind."
        case .awful:
            return "Be kind to yourself during this difficult time and seek support if needed."
        }
    }

    func getGoalSuggestions() -> [String] {
        return [
            "Meditate for 10 minutes every day",
            "Exercise for 30 minutes at least 3 days a week",
            "Drink 2 liters of water daily",
            "Keep a gratitude journal before bed every night",
            "Read a book for at least 15 minutes every day"
        ]
    }
}
