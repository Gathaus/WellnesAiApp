import Foundation
import Combine
import SwiftUI

class AIService: AIServiceProtocol {
    func generateResponse(to message: String) -> AnyPublisher<String, Never> {
        // Simple AI responses (should be replaced with a real API in production)
        let responses = [
            "How are you feeling today?",
            "I'm listening. Is there anything else you'd like to share?",
            "How is your day going?",
            "Taking time for yourself is important. How have you been kind to yourself today?",
            "Every challenge is an opportunity for personal growth.",
            "Even small progress is worth celebrating. Remember to appreciate yourself.",
            "Take a deep breath and enjoy the moment.",
            "Think of something that makes you feel good and focus on that feeling.",
            "Setting healthy boundaries is an important part of self-care.",
            "Make sure you're getting enough sleep, it's very important for your mental health.",
            "What are you grateful for right now?",
            "How can you reward yourself today?",
            "Observing yourself without judgment is the first step of mindfulness.",
            "Try to fully experience the present moment.",
            "Remember that sometimes just breathing can be meditation."
        ]
        
        return Just(responses.randomElement() ?? "I understand.")
            .delay(for: .seconds(1), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func getWellnessTips() -> [WellnessTip] {
        return [
            // Motivation tips
            WellnessTip(content: "Focus on one goal every day. Small steps lead to big results.", category: .motivation),
            WellnessTip(content: "Take a small step today toward realizing your dreams.", category: .motivation),
            WellnessTip(content: "Failures are learning opportunities, embrace them.", category: .motivation),
            WellnessTip(content: "Stepping outside your comfort zone is the key to growth.", category: .motivation),
            WellnessTip(content: "Compare yourself only to your past self, not to others.", category: .motivation),
            WellnessTip(content: "Every failure is a step on the path to success.", category: .motivation),
            WellnessTip(content: "Spend at least 15 minutes every day on something you're passionate about.", category: .motivation),

            // Mindfulness tips
            WellnessTip(content: "Try to meditate for at least 10 minutes every day.", category: .mindfulness),
            WellnessTip(content: "When you're struggling, focus on your breath and take a few deep breaths.", category: .mindfulness),
            WellnessTip(content: "Keeping a journal can help organize your thoughts.", category: .mindfulness),
            WellnessTip(content: "Try to experience meals with all your senses - eat slowly and mindfully.", category: .mindfulness),
            WellnessTip(content: "Once a day, ask yourself 'what am I feeling right now?'", category: .mindfulness),
            WellnessTip(content: "Learn to observe your thoughts without judgment, just notice and let go.", category: .mindfulness),
            WellnessTip(content: "Experience the present moment with your senses: see 5 things, touch 4 things, hear 3 things, smell 2 things, taste 1 thing.", category: .mindfulness),

            // Self-care tips
            WellnessTip(content: "Be kind to yourself, focus on progress rather than seeking perfection.", category: .selfCare),
            WellnessTip(content: "Spend at least 30 minutes in nature every day.", category: .selfCare),
            WellnessTip(content: "Good sleep is foundational for good mood. Create a regular sleep schedule.", category: .selfCare),
            WellnessTip(content: "Drink at least 8 glasses of water a day, hydration is important for both physical and mental health.", category: .selfCare),
            WellnessTip(content: "Take time to pamper yourself at least twice a week - a bath, reading a book, or your hobby.", category: .selfCare),
            WellnessTip(content: "Move for 30 minutes every day - walk, yoga, or dance - whatever makes you happy.", category: .selfCare),
            WellnessTip(content: "Learn to say 'no'. Setting boundaries is an important part of self-care.", category: .selfCare),

            // Positive thinking tips
            WellnessTip(content: "Be grateful for three things you do every day.", category: .positivity),
            WellnessTip(content: "Enjoy the little moments that make you happy.", category: .positivity),
            WellnessTip(content: "Notice negative thoughts and replace them with positive statements.", category: .positivity),
            WellnessTip(content: "Try to notice the beauty around you - a flower, the sky, or a smile.", category: .positivity),
            WellnessTip(content: "Every night before bed, remember three beautiful moments from the day.", category: .positivity),
            WellnessTip(content: "Spend time with positive people, energy is contagious.", category: .positivity),
            WellnessTip(content: "Learn to celebrate your small successes, it builds confidence.", category: .positivity)
        ]
    }
    
    func getDailyAffirmation() -> String {
        let affirmations = [
            "I am valuable and deserve to be loved.",
            "Every day, in every way, I am getting better and stronger.",
            "I have the power to overcome challenges.",
            "I can change my life in a positive way.",
            "I am good enough and I accept myself as I am.",
            "I feel grateful for today and every day.",
            "I have the power to create my own happiness.",
            "I radiate positive energy and attract positive energy.",
            "I am at peace.",
            "I love myself more each day.",
            "I am the architect of my life and make positive choices.",
            "I am fully present here and now, enjoying the moment.",
            "My worth is determined by who I am, not by my achievements.",
            "I approach myself with compassion and understanding.",
            "Every challenge strengthens and grows me.",
            "With each breath, I become calmer and more balanced.",
            "I respect my body and take good care of it.",
            "Meeting my own needs is not selfish, it's self-care.",
            "My life is full of beauty and opportunities.",
            "I have the freedom to choose at every moment, every day.",
            "I have the courage to change what I cannot accept, the serenity to accept what I cannot change, and the wisdom to know the difference."
        ]
        
        return affirmations.randomElement() ?? "Today will be a great day!"
    }

    func getPersonalizedRecommendation(based on: MoodType) -> String {
        switch on {
        case .fantastic:
            let recommendations = [
                "Note this great feeling. What did you do, who were you with? You can use this to create more of these moments.",
                "You can channel your positive energy into a creative activity. Maybe it's the perfect time to start that project you've been postponing!",
                "Share this great energy with your loved ones, maybe you can do an unexpected kindness for someone."
            ]
            return recommendations.randomElement() ?? "Make the most of this energetic state!"

        case .good:
            let recommendations = [
                "On this good day, give yourself a small reward or do an activity you enjoy.",
                "You could try keeping a gratitude journal to reinforce your positive emotions.",
                "Getting some fresh air today could contribute to your good feeling."
            ]
            return recommendations.randomElement() ?? "Enjoy this moment of feeling good."

        case .neutral:
            let recommendations = [
                "A short walk or breathing exercise could lift your mood.",
                "Listening to music or a podcast you enjoy could boost your energy.",
                "Try giving yourself a little extra care today - a favorite drink or a small break."
            ]
            return recommendations.randomElement() ?? "Take some time for yourself."

        case .bad:
            let recommendations = [
                "It's normal to feel bad. Instead of suppressing your emotions, maybe you could express them by writing.",
                "A short meditation or deep breathing exercise could help calm your mind.",
                "Talking to someone you love or messaging a friend could make you feel better."
            ]
            return recommendations.randomElement() ?? "Be kind to yourself, this feeling will pass."

        case .awful:
            let recommendations = [
                "When you feel awful, it's important to show yourself compassion. Today, focus just on your basic needs.",
                "Sharing your feelings with someone you trust or seeking professional support is an option to consider.",
                "Deep breathing exercises and short mindfulness practices can provide immediate relief."
            ]
            return recommendations.randomElement() ?? "Be kind to yourself during this difficult time and seek support if needed."
        }
    }

    func getGoalSuggestions() -> [String] {
        return [
            "Meditate for 10 minutes every day",
            "Exercise for 30 minutes at least 3 days a week",
            "Drink 2 liters of water daily",
            "Keep a gratitude journal before bed every night",
            "Read a book for at least 15 minutes every day",
            "Have a digital detox day once a week",
            "Start each day with a positive affirmation",
            "Set regular sleep hours and stick to them",
            "Spend time in nature at least twice a week",
            "Eat at least one meal mindfully every day",
            "Make and follow a weekly budget",
            "Set aside special time for myself once a week"
        ]
    }
}
