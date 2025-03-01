import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Binding var showSubscribeSheet: Bool
    @State private var selectedReminderTime = Date()
    @State private var reminderEnabled = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Profil kartı
                VStack(spacing: 20) {
                    // Avatar ve kullanıcı bilgileri
                    HStack {
                        // Avatar
                        ZStack {
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 70, height: 70)
                            
                            Text(String(viewModel.user?.name.prefix(1) ?? ""))
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            if let user = viewModel.user {
                                Text(user.name)
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                
                                Text("Üye: \(formatDate(user.createdAt))")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        // Düzenle butonu
                        Button(action: {
                            // Profil düzenleme ekranı
                        }) {
                            Image(systemName: "pencil")
                                .font(.system(size: 16))
                                .padding(8)
                                .background(Color("InputBackground"))
                                .clipShape(Circle())
                                .foregroundColor(.primary)
                        }
                    }
                    
                    // Abonelik durumu
                    VStack(spacing: 10) {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Ücretsiz Plan")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                
                                Text("Premium özellikleri keşfedin")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showSubscribeSheet = true
                            }) {
                                Text("Yükselt")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 8)
                                    .background(Color.accentColor)
                                    .cornerRadius(15)
                            }
                        }
                        
                        // İlerleme çubuğu
                        ProgressBar(value: .constant(0.2))
                            .frame(height: 6)
                        
                        Text("Premium özelliklerin %20'sine erişiminiz var")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color("InputBackground"))
                    )
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("CardBackground"))
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                )
                
                // Ayarlar
                VStack(spacing: 0) {
                    // Bölüm başlığı
                    Text("Ayarlar")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    
                    // Ayarlar listesi
                    VStack(spacing: 0) {
                        // Bildirimler
                        Toggle(isOn: $reminderEnabled) {
                            SettingRow(icon: "bell.fill", title: "Günlük Hatırlatıcılar", iconColor: .orange)
                        }
                        .onChange(of: reminderEnabled) { _ in
                            // Bildirim izinleri
                        }
                        .padding()
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // Bildirim zamanı
                        if reminderEnabled {
                            VStack {
                                DatePicker("Günlük hatırlatıcı zamanı", selection: $selectedReminderTime, displayedComponents: .hourAndMinute)
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                            }
                            
                            Divider()
                                .padding(.horizontal)
                        }
                        
                        // Karanlık mod
                        Toggle(isOn: $isDarkMode) {
                            SettingRow(icon: "moon.stars.fill", title: "Karanlık Mod", iconColor: .blue)
                        }
                        .padding()
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // Veri paylaşımı
                        Button(action: {
                            // Veri seçenekleri
                        }) {
                            SettingRow(icon: "chart.bar.fill", title: "Veri Paylaşımı", iconColor: .green)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // Dil seçenekleri
                        Button(action: {
                            // Dil seçenekleri
                        }) {
                            SettingRow(icon: "globe", title: "Dil Seçenekleri", iconColor: .purple)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color("CardBackground"))
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    )
                }
                
                // Destek ve hakkında
                VStack(spacing: 0) {
                    // Bölüm başlığı
                    Text("Destek & Hakkında")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    
                    // Liste
                    VStack(spacing: 0) {
                        // Yardım
                        Button(action: {
                            // Yardım sayfası
                        }) {
                            SettingRow(icon: "questionmark.circle.fill", title: "Yardım & Destek", iconColor: .blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // Gizlilik politikası
                        Button(action: {
                            // Gizlilik politikası
                        }) {
                            SettingRow(icon: "hand.raised.fill", title: "Gizlilik Politikası", iconColor: .gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // Kullanım şartları
                        Button(action: {
                            // Kullanım şartları
                        }) {
                            SettingRow(icon: "doc.text.fill", title: "Kullanım Şartları", iconColor: .gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // Uygulama hakkında
                        Button(action: {
                            // Uygulama hakkında
                        }) {
                            SettingRow(icon: "info.circle.fill", title: "Uygulama Hakkında", iconColor: .blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color("CardBackground"))
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    )
                }
                
                Spacer()
                    .frame(height: 100)
            }
            .padding(.horizontal)
        }
        .background(Color("BackgroundColor").ignoresSafeArea())
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
}

// Ayar satırı komponenti
struct SettingRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(iconColor)
                .cornerRadius(10)
            
            Text(title)
                .font(.system(size: 16, design: .rounded))
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
    }
}

// Abonelik ekranı
struct SubscriptionView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedPlan: SubscriptionPlan = .monthly
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Üst başlık
                    VStack(spacing: 10) {
                        Text("Premium'a Yükselt")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        
                        Text("Tüm premium özelliklere sınırsız erişim")
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
                                description: "Günlük, haftalık ve aylık ilerleme grafikleri"
                            )
                            
                            PremiumFeature(
                                icon: "bell.badge.fill",
                                title: "Kişiselleştirilmiş Bildirimler",
                                description: "Alışkanlıklarınıza göre özel hatırlatıcılar"
                            )
                            
                            PremiumFeature(
                                icon: "icloud.fill",
                                title: "Sınırsız Bulut Yedekleme",
                                description: "Tüm verilerinizi güvenle saklayın"
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
                        Text("Abonelik Planı Seçin")
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
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Şimdi Abone Ol")
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

// Premium özellik komponenti
struct PremiumFeature: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 42, height: 42)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

// Abonelik planı
enum SubscriptionPlan {
    case monthly
    case yearly
    case lifetime
}

// Plan kart komponenti
struct PlanCard: View {
    let plan: SubscriptionPlan
    @Binding var selectedPlan: SubscriptionPlan
    let title: String
    let price: String
    let description: String
    let savings: String
    
    var body: some View {
        Button(action: {
            selectedPlan = plan
        }) {
            HStack {
                // Seçim göstergesi
                ZStack {
                    Circle()
                        .stroke(Color.accentColor, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if selectedPlan == plan {
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 16, height: 16)
                    }
                }
                
                // Plan bilgileri
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                    
                    Text(description)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Fiyat
                VStack(alignment: .trailing, spacing: 3) {
                    Text(price)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                    
                    if !savings.isEmpty {
                        Text(savings)
                            .font(.system(size: 10))
                            .foregroundColor(.green)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(selectedPlan == plan ? Color.accentColor.opacity(0.1) : Color("InputBackground"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(selectedPlan == plan ? Color.accentColor : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

