import SwiftUI

// Lottie animasyon görünümü (UIViewRepresentable)
// Bu bir stub implementasyonu, gerçek projenizde LottieAnimationView kullanmanız gerekir
struct LottieView: View {
    let name: String

    var body: some View {
        Color.clear // Gerçek uygulamada burada Lottie animasyonu olacak
            .overlay(
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.white)
            )
    }
}

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieView(name: "user_profile")
            .frame(width: 150, height: 150)
            .previewLayout(.sizeThatFits)
            .background(Color.blue.opacity(0.2))
    }
}