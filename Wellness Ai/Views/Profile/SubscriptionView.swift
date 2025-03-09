import SwiftUI

struct SubscriptionView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: WellnessViewModel
    @State private var selectedPlan: SubscriptionPlan = .monthly

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Üst başlık
                    VStack(spacing: 10) {
                        Text("Upgrade to Premium")
                            .font(.system(size: 28, weight: .bold, design: .rounded))

                        Text("Unlimited access to all premium features")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)

                    // Premium özellikler
                    VStack(spacing: 15) {
                        Text("Premium Özellikler")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // Özellik listesi
                        VStack(spacing: 15) {
                            PremiumFeature(
                                icon: "waveform.path.ecg",
                                title: "Gelişmiş Meditasyonlar",
                                description: "80+ farklı meditasyon içeriğine erişin"
                            )

                            PremiumFeature(
                                icon: "chart.bar.fill",
                                title: "Detaylı İstatistikler",
                                description: "Daily, weekly and monthly progress charts"
                            )

                            PremiumFeature(
                                icon: "bell.badge.fill",
                                title: "Kişiselleştirilmiş Bildirimler",
                                description: "Alışkanlıklarınıza göre özel hatırlatıcılar"
                            )

                            PremiumFeature(
                                icon: "icloud.fill",
                                title: "Sınırsız Bulut Yedekleme",
                                description: "Securely store all your data"
                            )
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color("CardBackground"))
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    )

                    // Abonelik planları
                    VStack(spacing: 15) {
                        Text("Choose Subscription Plan")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // Plan seçenekleri
                        VStack(spacing: 15) {
                            // Aylık plan
                            PlanCard(
                                plan: .monthly,
                                selectedPlan: $selectedPlan,
                                title: "Aylık",
                                price: "₺39,99",
                                description: "Her ay otomatik yenilenir",
                                savings: ""
                            )

                            // Yıllık plan
                            PlanCard(
                                plan: .yearly,
                                selectedPlan: $selectedPlan,
                                title: "Yıllık",
                                price: "₺299,99",
                                description: "Her yıl otomatik yenilenir",
                                savings: "₺179,89 tasarruf edin (%38)"
                            )

                            // Ömür boyu
                            PlanCard(
                                plan: .lifetime,
                                selectedPlan: $selectedPlan,
                                title: "Ömür Boyu",
                                price: "₺999,99",
                                description: "Tek seferlik ödeme",
                                savings: "Sınırsız erişim"
                            )
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color("CardBackground"))
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    )

                    // Abone ol butonu
                    Button(action: {
                        // Ödeme işlemleri
                        viewModel.updatePremiumStatus(true)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Subscribe Now")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(15)
                            .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.top, 10)

                    // Bilgilendirme metni
                    Text("Aboneliğiniz, dönem sonunda otomatik olarak yenilenir. İstediğiniz zaman ayarlardan iptal edebilirsiniz.")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 10)
                }
                .padding()
            }
            .background(Color("BackgroundColor").ignoresSafeArea())
            .navigationBarItems(
                trailing: Button("Kapat") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
            .environmentObject(WellnessViewModel())
    }
}