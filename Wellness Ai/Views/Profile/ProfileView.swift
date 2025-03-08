import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Binding var showSubscribeSheet: Bool
    @State private var showFeedbackSheet = false

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

                        // Veri paylaşımı
                        Button(action: {
                            // Veri seçenekleri
                        }) {
                            SettingRow(icon: "chart.bar.fill", title: "Veri Paylaşımı", iconColor: .purple)
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

                // Destek ve hakkında - with actual content
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
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
}

struct HelpSheetView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        Text("Nasıl Kullanılır?")
                            .font(.system(size: 22, weight: .bold, design: .rounded))

                        Text("WellnessAI, zihinsel ve duygusal sağlığınızı desteklemek için tasarlanmış kişisel asistanınızdır. Uygulama ile günlük ruh halinizi takip edebilir, meditasyon yapabilir, ilham verici sözler okuyabilir ve yapay zeka asistanı ile sohbet edebilirsiniz.")
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

// New Feedback View
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