import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @State private var currentPage = 0
    @State private var name = ""
    
    // Onboarding sayfaları
    let pages = [
        OnboardingPage(
            title: "WellnessAI'ya Hoş Geldiniz",
            description: "Zihinsel ve duygusal sağlığınızı desteklemek için tasarlanmış kişisel asistanınız",
            imageName: "brain.head.profile",
            backgroundColor: Color(hex: "5E72EB")
        ),
        OnboardingPage(
            title: "Günlük Pozitiflik",
            description: "Her gün size özel afirmasyonlar ve size özel motivasyon mesajları alın",
            imageName: "sun.max.fill",
            backgroundColor: Color(hex: "FF9190")
        ),
        OnboardingPage(
            title: "Akıllı Wellness Asistanı",
            description: "Sohbet ederek, deneyimlerinizi paylaşarak ve kişisel rehberlik alarak iç huzurunuzu keşfedin",
            imageName: "message.and.waveform.fill",
            backgroundColor: Color(hex: "43B692")
        )
    ]
    
    var body: some View {
        ZStack {
            // Arkaplan
            pages[currentPage].backgroundColor
                .ignoresSafeArea()
            
            VStack {
                // Üst kısım - sayfa göstergesi
                HStack {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(Color.white.opacity(currentPage == index ? 1.0 : 0.4))
                            .frame(width: currentPage == index ? 20 : 7, height: 7)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.top, 30)
                
                // Görseller ve içerik
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: pages[index].imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 180, height: 180)
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: 240, height: 240)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 3)
                                        .frame(width: 270, height: 270)
                                )
                            
                            Text(pages[index].title)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.top, 30)
                            
                            Text(pages[index].description)
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                                .padding(.top, 10)
                            
                            Spacer()
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // İsim giriş formu son sayfada gösterilir
                if currentPage == pages.count - 1 {
                    VStack(spacing: 25) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("İsminiz nedir?")
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                .foregroundColor(.white)
                            
                            TextField("", text: $name)
                                .font(.system(size: 17, design: .rounded))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                                )
                        }
                        .padding(.horizontal, 30)
                        
                        Button(action: {
                            if !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                viewModel.createUser(name: name)
                            }
                        }) {
                            Text("Wellness Yolculuğuma Başla")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(pages[currentPage].backgroundColor)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 30)
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                } else {
                    // Devam et butonu
                    Button(action: {
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        HStack {
                            Text("Devam Et")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(pages[currentPage].backgroundColor)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(pages[currentPage].backgroundColor)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                }
            }
        }
        .animation(.easeInOut, value: currentPage)
    }
}

// Onboarding sayfa modeli
struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let backgroundColor: Color
}

// HEX renk oluşturucu extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
