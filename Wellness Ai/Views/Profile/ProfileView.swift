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
                                Text(viewModel.isPremium ? "Premium Plan" : "Ücretsiz Plan")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))

                                Text(viewModel.isPremium ? "Tüm premium özelliklere erişiminiz var" : "Premium özellikleri keşfedin")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            if !viewModel.isPremium {
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
                        }

                        // İlerleme çubuğu
                        ProgressBar(value: .constant(viewModel.isPremium ? 1.0 : 0.2))
                            .frame(height: 6)

                        Text(viewModel.isPremium ? "Premium üyelik aktif" : "Premium özelliklerin %20'sine erişiminiz var")
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(showSubscribeSheet: .constant(false))
            .environmentObject(WellnessViewModel())
    }
}