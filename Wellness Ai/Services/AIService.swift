import Foundation
import Combine

protocol AIServiceProtocol {
    func generateResponse(to message: String) -> AnyPublisher<String, Never>
    func getWellnessTips() -> [WellnessTip]
    func getDailyAffirmation() -> String
}

// AI Servis - AI ile etkileşim mantığı
final class AIService2: AIServiceProtocol {
    private var cancellables = Set<AnyCancellable>()
    private let responseDelay: TimeInterval
    
    init(responseDelay: TimeInterval = 1.0) {
        self.responseDelay = responseDelay
    }
    
    // Gerçek bir AI API'si ile değiştirilmelidir
    func generateResponse(to message: String) -> AnyPublisher<String, Never> {
        // Basit yapay yanıtlar (gerçek uygulamada bir API ile değiştirilmelidir)
        let responses = [
            "Bugün kendini nasıl hissediyorsun?",
            "Seni dinliyorum. Paylaşmak istediğin başka şeyler var mı?",
            "Günün nasıl geçiyor?",
            "Kendine biraz zaman ayırmak önemlidir. Bugün kendine nasıl iyi davrandın?",
            "Her zorluk, kişisel gelişim için bir fırsattır.",
            "Küçük ilerlemeler bile kutlanmaya değer. Kendini takdir etmeyi unutma.",
            "Derin bir nefes al ve anın tadını çıkar.",
            "Kendini iyi hissettiğin bir şeyi hatırla ve o duyguya odaklan."
        ]
        
        return Future<String, Never> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + self.responseDelay) {
                let response = responses.randomElement() ?? "Seni anlıyorum."
                promise(.success(response))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getWellnessTips() -> [WellnessTip] {
        return [
            WellnessTip(content: "Günde en az 10 dakika meditasyon yapmayı deneyin.", category: .mindfulness),
            WellnessTip(content: "Her gün yaptığınız üç şey için minnettar olun.", category: .positivity),
            WellnessTip(content: "Kendinize karşı nazik olun, mükemmellik aramak yerine ilerlemeye odaklanın.", category: .selfCare),
            WellnessTip(content: "Hayallerinizi gerçekleştirmek için bugün küçük bir adım atın.", category: .motivation),
            WellnessTip(content: "Her gün en az 30 dakika doğada zaman geçirin.", category: .selfCare),
            WellnessTip(content: "Sizi mutlu eden küçük anların tadını çıkarın.", category: .positivity),
            WellnessTip(content: "Zorlandığınızda, nefesinize odaklanın ve birkaç derin nefes alın.", category: .mindfulness),
            WellnessTip(content: "Başarısızlıklar öğrenme fırsatıdır, onları kucaklayın.", category: .motivation),
            WellnessTip(content: "İyi uyku, iyi ruh hali için temeldir. Düzenli bir uyku programı oluşturun.", category: .selfCare),
            WellnessTip(content: "Olumsuz düşünceleri fark edin ve onları olumlu ifadelerle değiştirin.", category: .positivity),
            WellnessTip(content: "Günlük tutmak, düşüncelerinizi düzenlemenize yardımcı olabilir.", category: .mindfulness),
            WellnessTip(content: "Konfor alanınızın dışına çıkmak, büyümenin anahtarıdır.", category: .motivation)
        ]
    }
    
    func getDailyAffirmation() -> String {
        let affirmations = [
            "Ben değerliyim ve sevilmeyi hak ediyorum.",
            "Her gün, her şekilde daha iyi ve daha güçlü oluyorum.",
            "Zorlukları aşabilecek güce sahibim.",
            "Hayatımı olumlu bir şekilde değiştirebilirim.",
            "Ben yeterince iyiyim ve olduğum gibi kendimi kabul ediyorum.",
            "Bugün ve her gün için minnettar hissediyorum.",
            "Kendi mutluluğumu yaratma gücüne sahibim.",
            "Pozitif enerji yayıyor ve pozitif enerji çekiyorum.",
            "Ben barış ve huzur içindeyim.",
            "Her geçen gün kendimi daha çok seviyorum."
        ]
        
        return affirmations.randomElement() ?? "Bugün harika bir gün olacak!"
    }
}
