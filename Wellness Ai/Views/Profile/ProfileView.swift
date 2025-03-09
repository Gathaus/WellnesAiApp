import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Binding var showSubscribeSheet: Bool
    @State private var showFeedbackSheet = false
    @State private var showEditProfileSheet = false
    @State private var showHelpSheet = false
    @State private var showPrivacySheet = false
    @State private var showTermsSheet = false
    @State private var showAboutSheet = false
    @State private var editingName = ""

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
                            if let user = viewModel.user {
                                editingName = user.name
                            }
                            showEditProfileSheet = true
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
                        // Karanlık mod
                        Toggle(isOn: $isDarkMode) {
                            SettingRow(icon: "moon.stars.fill", title: "Karanlık Mod", iconColor: .blue)
                        }
                        .padding()

                        Divider()
                            .padding(.horizontal)

                        // Geri bildirim
                        Button(action: {
                            showFeedbackSheet = true
                        }) {
                            SettingRow(icon: "hand.thumbsup.fill", title: "Geri Bildirim Gönder", iconColor: .green)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()

                        Divider()
                            .padding(.horizontal)

                        // Dil seçenekleri
                        Button(action: {
                            // Dil seçenekleri
                        }) {
                            SettingRow(icon: "globe", title: "Dil Seçenekleri", iconColor: .orange)
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
                            showHelpSheet = true
                        }) {
                            SettingRow(icon: "questionmark.circle.fill", title: "Yardım & Destek", iconColor: .blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()

                        Divider()
                            .padding(.horizontal)

                        // Gizlilik politikası
                        Button(action: {
                            showPrivacySheet = true
                        }) {
                            SettingRow(icon: "hand.raised.fill", title: "Gizlilik Politikası", iconColor: .gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()

                        Divider()
                            .padding(.horizontal)

                        // Kullanım şartları
                        Button(action: {
                            showTermsSheet = true
                        }) {
                            SettingRow(icon: "doc.text.fill", title: "Kullanım Şartları", iconColor: .gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()

                        Divider()
                            .padding(.horizontal)

                        // Uygulama hakkında
                        Button(action: {
                            showAboutSheet = true
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

                // App info text
                VStack(spacing: 10) {
                    Text("WellnessAI")
                        .font(.system(size: 20, weight: .bold, design: .rounded))

                    Text("Sürüm 1.0.0")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)

                    Text("© 2025 Wellness AI. Tüm hakları saklıdır.")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .padding(.top, 5)
                }
                .padding()

                Spacer()
                    .frame(height: 100)
            }
            .padding(.horizontal)
        }
        .background(Color("BackgroundColor").ignoresSafeArea())
        .sheet(isPresented: $showFeedbackSheet) {
            FeedbackView()
        }
        .sheet(isPresented: $showEditProfileSheet) {
            EditProfileView(name: $editingName, onSave: { newName in
                if !newName.isEmpty, let user = viewModel.user {
                    var updatedUser = user
                    updatedUser.name = newName
                    viewModel.user = updatedUser
                    viewModel.saveUser(updatedUser)
                }
            })
        }
        .sheet(isPresented: $showHelpSheet) {
            HelpSheetView()
        }
        .sheet(isPresented: $showPrivacySheet) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $showTermsSheet) {
            TermsOfServiceView()
        }
        .sheet(isPresented: $showAboutSheet) {
            AboutAppView()
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
}

// Edit Profile View
struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var name: String
    let onSave: (String) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profil Bilgileri")) {
                    TextField("İsim", text: $name)
                        .font(.system(size: 17))
                        .padding(.vertical, 8)
                }

                // Additional fields could be added here in the future
            }
            .navigationBarTitle("Profili Düzenle", displayMode: .inline)
            .navigationBarItems(
                leading: Button("İptal") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Kaydet") {
                    onSave(name)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            )
        }
    }
}

// Help Sheet View
struct HelpSheetView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        Text("How to Use?")
                            .font(.system(size: 22, weight: .bold, design: .rounded))

                        Text("WellnessAI is your personal assistant designed to support your mental and emotional health. With the app, you can track daily mood, meditate, read inspirational quotes, and chat with AI assistant.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("Ana Sayfa")
                            .font(.system(size: 18, weight: .bold))

                        Text("Günlük ruh halinizi kaydedin ve takip edin. Hızlı erişim kartları ile diğer bölümlere kolayca ulaşabilirsiniz.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("Meditasyon")
                            .font(.system(size: 18, weight: .bold))

                        Text("Farklı kategorilerde meditasyon seansları bulabilir ve iç huzurunuzu artırabilirsiniz.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("Sohbet Asistanı")
                            .font(.system(size: 18, weight: .bold))

                        Text("Duygusal destek veya motivasyon için yapay zeka asistanımızla konuşabilirsiniz.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("İlham Köşesi")
                            .font(.system(size: 18, weight: .bold))

                        Text("Günlük olumlamalar ve motivasyon sözleri ile pozitif düşünmeyi destekleyin.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("Premium")
                            .font(.system(size: 18, weight: .bold))

                        Text("Premium üyelik ile daha fazla meditasyon, sınırsız sohbet ve özelleştirilmiş öneriler elde edin.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("İletişim")
                            .font(.system(size: 18, weight: .bold))

                        Text("Destek için: destek@wellnessai.com")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Yardım & Destek", displayMode: .inline)
            .navigationBarItems(trailing: Button("Kapat") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// Privacy Policy View
struct PrivacyPolicyView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        Text("Gizlilik Politikası")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .padding(.bottom, 10)

                        Text("Son Güncelleme: 1 Mart 2025")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .padding(.bottom, 20)

                        Text("Bu gizlilik politikası, WellnessAI uygulamasını kullanırken toplanan, kullanılan ve paylaşılan bilgileri açıklar. Uygulamayı kullanarak, bu politikada belirtilen veri toplama ve kullanım uygulamalarını kabul etmiş olursunuz.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("Toplanan Bilgiler")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top, 10)

                        Text("Uygulama, size daha iyi bir deneyim sunmak için aşağıdaki bilgileri toplayabilir:\n\n• Profil bilgileri (isim, tercihler)\n• Uygulama kullanım verileri\n• Ruh hali ve hedef takip verileri\n• Cihaz bilgileri")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("Verilerin Kullanımı")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top, 10)

                        Text("Toplanan veriler şu amaçlarla kullanılabilir:\n\n• Uygulamanın özelliklerini sağlamak ve iyileştirmek\n• Kişiselleştirilmiş içerik ve öneriler sunmak\n• Uygulama performansını analiz etmek\n• Teknik sorunları çözmek")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("Veri Güvenliği")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top, 10)

                        Text("Verilerinizin güvenliği bizim için önemlidir. Uygun güvenlik önlemleri kullanarak verilerinizi korumak için çaba gösteriyoruz.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("Üçüncü Taraflarla Paylaşım")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top, 10)

                        Text("Kişisel verilerinizi, yasal yükümlülüklerimizi yerine getirmek veya haklarımızı korumak için gereken durumlar dışında üçüncü taraflarla paylaşmıyoruz.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("Değişiklikler")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top, 10)

                        Text("Bu gizlilik politikasını zaman zaman güncelleyebiliriz. Önemli değişiklikler yapıldığında, uygulama içinde bildirim alacaksınız.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("İletişim")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top, 10)

                        Text("Gizlilik politikamızla ilgili sorularınız varsa, lütfen privacy@wellnessai.com adresine e-posta gönderin.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Gizlilik Politikası", displayMode: .inline)
            .navigationBarItems(trailing: Button("Kapat") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// Terms of Service View
struct TermsOfServiceView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        Text("Terms of Service")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .padding(.bottom, 10)

                        Text("Son Güncelleme: 1 Mart 2025")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .padding(.bottom, 20)

                        Text("Bu kullanım şartları, WellnessAI uygulamasını kullanırken uymanız gereken kuralları ve hükümleri belirtir. Uygulamayı kullanarak, bu şartları kabul etmiş olursunuz.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("Kullanım Lisansı")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top, 10)

                        Text("WellnessAI, size kişisel ve ticari olmayan kullanım için sınırlı, münhasır olmayan, devredilemez bir lisans verir. Bu lisans, uygulamayı kopyalamak, değiştirmek veya yeniden dağıtmak için izin vermez.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("Kullanıcı Davranışları")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top, 10)

                        Text("Uygulamayı kullanırken, yasalara uygun hareket etmeyi ve başkalarının haklarına saygı göstermeyi kabul edersiniz. Uygulamayı kötüye kullanmak, güvenliğini tehlikeye atmak veya diğer kullanıcıları rahatsız etmek yasaktır.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("Hizmet Değişiklikleri")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top, 10)

                        Text("WellnessAI, herhangi bir zamanda ve herhangi bir nedenle uygulamayı değiştirme, askıya alma veya sonlandırma hakkını saklı tutar.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("Sorumluluk Sınırlaması")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top, 10)

                        Text("WellnessAI, uygulama kullanımından kaynaklanan doğrudan, dolaylı, özel, arızi veya cezai zararlardan sorumlu değildir.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("Yönetim Hukuku")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top, 10)

                        Text("Bu şartlar, Türkiye Cumhuriyeti yasalarına tabidir ve bu yasalara göre yorumlanacaktır.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("Değişiklikler")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top, 10)

                        Text("Bu kullanım şartlarını zaman zaman güncelleyebiliriz. Önemli değişiklikler yapıldığında, uygulama içinde bildirim alacaksınız.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("İletişim")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top, 10)

                        Text("Kullanım şartlarımızla ilgili sorularınız varsa, lütfen terms@wellnessai.com adresine e-posta gönderin.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Kullanım Şartları", displayMode: .inline)
            .navigationBarItems(trailing: Button("Kapat") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// About App View
struct AboutAppView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        // App logo
                        HStack {
                            Spacer()

                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 100, height: 100)

                                Text("W")
                                    .font(.system(size: 50, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }

                            Spacer()
                        }
                        .padding(.vertical, 20)

                        Text("WellnessAI")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .center)

                        Text("Version 1.0.0 (Build 1)")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 30)
                    }

                    Group {
                        Text("About the App")
                            .font(.system(size: 18, weight: .bold))

                        Text("WellnessAI, zihinsel ve duygusal sağlığınızı desteklemek için tasarlanmış kişisel bir asistanıdır. Yapay zeka destekli özellikler ve bilimsel yaklaşımlarla, kullanıcıların daha sağlıklı ve dengeli bir yaşam sürmelerine yardımcı olmayı amaçlıyoruz.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("Özellikler")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top, 10)

                        Text("• Günlük ruh hali takibi ve analizi\n• Kişiselleştirilmiş meditasyon önerileri\n• Yapay zeka destekli sohbet asistanı\n• İlham verici günlük olumlamalar\n• Kişisel hedef belirleme ve takip")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("Ekibimiz")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top, 10)

                        Text("WellnessAI, psikoloji, teknoloji ve iyi yaşam konularında tutkulu bir ekip tarafından geliştirilmiştir. Amacımız, herkesin zihinsel sağlığına önem vermesine ve kişisel gelişim yolculuğunda destek sağlamaktır.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("İletişim")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top, 10)

                        Text("Web: www.wellnessai.com\nE-posta: info@wellnessai.com\nSosyal Medya: @wellnessai")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Group {
                        Text("© 2025 Wellness AI. Tüm hakları saklıdır.")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 30)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Uygulama Hakkında", displayMode: .inline)
            .navigationBarItems(trailing: Button("Kapat") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// Feedback View
struct FeedbackView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var feedbackText = ""
    @State private var feedbackType = 0
    @State private var contactEmail = ""
    @State private var showSuccessAlert = false

    let feedbackTypes = ["Öneri", "Problem Bildirimi", "Yeni Özellik İsteği", "Diğer"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Geri Bildirim Türü")) {
                    Picker("Tür", selection: $feedbackType) {
                        ForEach(0..<feedbackTypes.count, id: \.self) { index in
                            Text(feedbackTypes[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Düşünceleriniz")) {
                    TextEditor(text: $feedbackText)
                        .frame(minHeight: 150)
                        .padding(5)
                }

                Section(header: Text("İletişim (İsteğe bağlı)")) {
                    TextField("Email", text: $contactEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }

                Section {
                    Button(action: {
                        // Here you would normally send the feedback
                        // For this example, we just show a success message
                        showSuccessAlert = true
                    }) {
                        Text("Gönder")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(feedbackText.isEmpty ? Color.gray : Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(feedbackText.isEmpty)
                }
            }
            .navigationBarTitle("Geri Bildirim", displayMode: .inline)
            .navigationBarItems(trailing: Button("İptal") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showSuccessAlert) {
                Alert(
                    title: Text("Teşekkürler!"),
                    message: Text("Geri bildiriminiz için teşekkür ederiz. Düşünceleriniz bizim için değerli."),
                    dismissButton: .default(Text("Tamam")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(showSubscribeSheet: .constant(false))
            .environmentObject(WellnessViewModel())
    }
}
