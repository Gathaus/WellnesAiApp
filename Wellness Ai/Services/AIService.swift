import Foundation
import Combine

class AIService: AIServiceProtocol {
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
            "Kendini iyi hissettiğin bir şeyi hatırla ve o duyguya odaklan.",
            "Sağlıklı sınırlar belirlemek öz bakımın önemli bir parçasıdır.",
            "Yeterince uyku aldığından emin ol, bu zihinsel sağlığın için çok önemli.",
            "Şu anda neye minnettar hissediyorsun?",
            "Bugün kendini nasıl ödüllendirebilirsin?",
            "Kendini yargılamadan gözlemlemek, farkındalığın ilk adımıdır.",
            "İçinde bulunduğun anı tam olarak yaşamaya çalış.",
            "Bazen sadece nefes almanın bile meditasyon olduğunu hatırla."
        ]
        
        return Just(responses.randomElement() ?? "Seni anlıyorum.")
            .delay(for: .seconds(1), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func getWellnessTips() -> [WellnessTip] {
        return [
            // Motivasyon ipuçları
            WellnessTip(content: "Her gün bir hedefe odaklanın. Küçük adımlar büyük sonuçlara götürür.", category: .motivation),
            WellnessTip(content: "Hayallerinizi gerçekleştirmek için bugün küçük bir adım atın.", category: .motivation),
            WellnessTip(content: "Başarısızlıklar öğrenme fırsatıdır, onları kucaklayın.", category: .motivation),
            WellnessTip(content: "Konfor alanınızın dışına çıkmak, büyümenin anahtarıdır.", category: .motivation),
            WellnessTip(content: "Kendinizi diğerleriyle değil, sadece dünkü kendinizle karşılaştırın.", category: .motivation),
            WellnessTip(content: "Her başarısızlık, başarıya giden yolda bir adımdır.", category: .motivation),
            WellnessTip(content: "Tutkulu olduğunuz bir şey için her gün en az 15 dakika ayırın.", category: .motivation),

            // Farkındalık ipuçları
            WellnessTip(content: "Günde en az 10 dakika meditasyon yapmayı deneyin.", category: .mindfulness),
            WellnessTip(content: "Zorlandığınızda, nefesinize odaklanın ve birkaç derin nefes alın.", category: .mindfulness),
            WellnessTip(content: "Günlük tutmak, düşüncelerinizi düzenlemenize yardımcı olabilir.", category: .mindfulness),
            WellnessTip(content: "Yemek yerken tüm duyularınızla deneyimlemeye çalışın - yavaşça ve farkında olarak yiyin.", category: .mindfulness),
            WellnessTip(content: "Günde bir kez 'şu anda ne hissediyorum?' diye kendinize sorun.", category: .mindfulness),
            WellnessTip(content: "Düşüncelerinizi yargılamadan gözlemlemeyi öğrenin, sadece fark edin ve bırakın.", category: .mindfulness),
            WellnessTip(content: "Duyularınızla şu anı deneyimleyin: 5 şey görün, 4 şey dokunun, 3 şey duyun, 2 şey koklayın, 1 şey tadın.", category: .mindfulness),

            // Öz bakım ipuçları
            WellnessTip(content: "Kendinize karşı nazik olun, mükemmellik aramak yerine ilerlemeye odaklanın.", category: .selfCare),
            WellnessTip(content: "Her gün en az 30 dakika doğada zaman geçirin.", category: .selfCare),
            WellnessTip(content: "İyi uyku, iyi ruh hali için temeldir. Düzenli bir uyku programı oluşturun.", category: .selfCare),
            WellnessTip(content: "Günde en az 8 bardak su için, hidrasyon hem fiziksel hem de zihinsel sağlık için önemlidir.", category: .selfCare),
            WellnessTip(content: "Haftada en az iki kez kendinize şımartma zamanı ayırın - bir banyo, kitap okuma veya hobiniz.", category: .selfCare),
            WellnessTip(content: "Her gün 30 dakika hareket edin - yürüyüş, yoga veya dans - ne sizi mutlu ediyorsa.", category: .selfCare),
            WellnessTip(content: "'Hayır' demeyi öğrenin. Sınırlar belirlemek, öz bakımın önemli bir parçasıdır.", category: .selfCare),

            // Pozitif düşünce ipuçları
            WellnessTip(content: "Her gün yaptığınız üç şey için minnettar olun.", category: .positivity),
            WellnessTip(content: "Sizi mutlu eden küçük anların tadını çıkarın.", category: .positivity),
            WellnessTip(content: "Olumsuz düşünceleri fark edin ve onları olumlu ifadelerle değiştirin.", category: .positivity),
            WellnessTip(content: "Çevrenizdeki güzellikleri fark etmeye çalışın - bir çiçek, gökyüzü veya bir gülümseme.", category: .positivity),
            WellnessTip(content: "Her gece yatmadan önce günün üç güzel anını hatırlayın.", category: .positivity),
            WellnessTip(content: "Pozitif insanlarla vakit geçirin, enerji bulaşıcıdır.", category: .positivity),
            WellnessTip(content: "Küçük başarılarınızı kutlamayı öğrenin, bu özgüveninizi artırır.", category: .positivity)
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
            "Her geçen gün kendimi daha çok seviyorum.",
            "Ben kendi hayatımın mimarıyım ve olumlu seçimler yapıyorum.",
            "Şu anda tamamen buradayım ve anın tadını çıkarıyorum.",
            "Benim değerim, başarılarımla değil, kim olduğumla belirlenir.",
            "Ben kendime şefkat ve anlayışla yaklaşıyorum.",
            "Her zorluk beni güçlendirir ve büyütür.",
            "Her nefesle daha da sakinleşiyor ve dengeleniyorum.",
            "Bedenime saygı duyuyor ve iyi bakıyorum.",
            "Kendi ihtiyaçlarımı karşılamak bencillik değil, öz bakımdır.",
            "Hayatım güzellikler ve fırsatlarla dolu.",
            "Ben her gün, her an seçim yapabilme özgürlüğüne sahibim.",
            "Kabul edemeyeceğim şeyleri değiştirme cesaretine, değiştiremeyeceğim şeyleri kabul etme huzuruna ve ikisini birbirinden ayırt etme bilgeliğine sahibim."
        ]
        
        return affirmations.randomElement() ?? "Bugün harika bir gün olacak!"
    }

    func getPersonalizedRecommendation(based on: MoodType) -> String {
        switch on {
        case .fantastic:
            let recommendations = [
                "Harika hissettiğiniz bu duyguyu not edin. Ne yaptınız, kimlerle birlikte oldunuz? Bu anları çoğaltmak için kullanabilirsiniz.",
                "Pozitif enerjinizi yaratıcı bir aktiviteye yönlendirebilirsiniz. Belki o ertelediğiniz projeye başlamak için mükemmel bir zaman!",
                "Bu harika enerjiyi sevdiklerinizle paylaşın, belki birisine beklenmedik bir iyilik yapabilirsiniz."
            ]
            return recommendations.randomElement() ?? "Bu enerjik halinizi değerlendirin!"

        case .good:
            let recommendations = [
                "İyi hissettiğiniz bu günde, kendinize küçük bir ödül verin veya sevdiğiniz bir aktivite yapın.",
                "Olumlu duygularınızı pekiştirmek için minnettarlık günlüğü tutmayı deneyebilirsiniz.",
                "Bugün biraz dışarı çıkıp temiz hava almak iyi hissetmenize katkıda bulunabilir."
            ]
            return recommendations.randomElement() ?? "İyi hissettiğiniz bu anın tadını çıkarın."

        case .neutral:
            let recommendations = [
                "Kısa bir yürüyüş veya nefes egzersizi ruh halinizi yükseltebilir.",
                "Sevdiğiniz bir müzik veya podcast dinlemek enerjinizi artırabilir.",
                "Bugün kendinize biraz ekstra özen göstermeyi deneyin - sevdiğiniz bir içecek veya küçük bir mola."
            ]
            return recommendations.randomElement() ?? "Kendinize biraz zaman ayırın."

        case .bad:
            let recommendations = [
                "Kötü hissetmek normaldir. Duygularınızı bastırmak yerine, belki onları yazarak ifade edebilirsiniz.",
                "Kısa bir meditasyon veya derin nefes egzersizi zihninizi sakinleştirmeye yardımcı olabilir.",
                "Sevdiğiniz biriyle konuşmak veya bir arkadaşınızla mesajlaşmak sizi daha iyi hissettirebilir."
            ]
            return recommendations.randomElement() ?? "Kendinize nazik davranın, bu duygu da geçecek."

        case .awful:
            let recommendations = [
                "Çok kötü hissettiğinizde kendine şefkat göstermek önemlidir. Bugün sadece temel ihtiyaçlarınıza odaklanın.",
                "Duygularınızı güvenilir biriyle paylaşmak veya profesyonel destek almak düşünebileceğiniz bir seçenektir.",
                "Derin nefes alma egzersizleri ve kısa mindfulness pratikleri anlık rahatlama sağlayabilir."
            ]
            return recommendations.randomElement() ?? "Bu zor zamanda kendinize nazik olun ve gerekirse destek alın."
        }
    }

    func getGoalSuggestions() -> [String] {
        return [
            "Her gün 10 dakika meditasyon yapmak",
            "Haftada en az 3 gün 30 dakika egzersiz yapmak",
            "Günde 2 litre su içmek",
            "Her gece uyumadan önce şükran günlüğü tutmak",
            "Her gün en az 15 dakika kitap okumak",
            "Haftada bir gün dijital detoks yapmak",
            "Her sabah güne olumlu bir afirmasyonla başlamak",
            "Düzenli uyku saatleri belirlemek ve uymak",
            "Haftada en az 2 kez doğada zaman geçirmek",
            "Her gün en az bir öğünü farkındalıkla yemek",
            "Haftalık bütçe planı yapıp izlemek",
            "Haftada bir kez kendime özel zaman ayırmak"
        ]
    }
}