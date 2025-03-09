import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @State private var currentPage = 0
    @State private var name = ""
    @State private var age: Int = 30
    @State private var selectedGoals: [String] = []
    @State private var stressLevel: Int = 3
    @State private var selectedChallenges: [String] = []
    @State private var isKeyboardVisible = false

    // Onboarding sayfaları
    let pages = [
        OnboardingPage(
            title: "Welcome to WellnessAI",
            description: "Your personalized assistant to support mental and emotional health",
            imageName: "brain.head.profile",
            backgroundColor: Color(hex: "5E72EB")
        ),
        OnboardingPage(
            title: "Your Personal Assistant",
            description: "WellnessAI supports your well-being with meditation, positive thinking and daily motivation",
            imageName: "person.fill.checkmark",
            backgroundColor: Color(hex: "FF9190")
        ),
        OnboardingPage(
            title: "Achieve Mental Peace",
            description: "Customized recommendations to help you handle daily stress and challenges",
            imageName: "cloud.sun.fill",
            backgroundColor: Color(hex: "43B692")
        )
    ]

    // Wellness hedefleri
    let wellnessGoals = [
        "Reduce stress",
        "Improve sleep",
        "Increase mindfulness",
        "Positive thinking",
        "Boost motivation",
        "Improve focus",
        "Reduce anxiety"
    ]

    // Zorluklar
    let challenges = [
        "Stress",
        "Sleep issues",
        "Low motivation",
        "Anxiety",
        "Concentration difficulties",
        "Olumsuz düşünceler",
        "İş/yaşam dengesi",
        "Enerji eksikliği"
    ]

    var body: some View {
        ZStack {
            // Arkaplan
            LinearGradient(
                gradient: Gradient(colors: [
                    pages[min(currentPage, pages.count - 1)].backgroundColor,
                    pages[min(currentPage, pages.count - 1)].backgroundColor.opacity(0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Arkaplan dekoratif elemanlar
            backgroundDecorations

            VStack(spacing: 0) {
                // Üst kısım - sayfa göstergesi
                pageIndicator

                if currentPage < pages.count {
                    // Tanıtım sayfaları
                    introPages
                } else if currentPage == pages.count {
                    // Kullanıcı bilgileri sayfası
                    userInfoPage
                } else if currentPage == pages.count + 1 {
                    // Hedefler sayfası
                    goalsPage
                } else {
                    // Zorluklar sayfası
                    challengesPage
                }
            }
            .animation(.easeInOut, value: currentPage)
        }
        .onAppear {
            setupKeyboardObservers()
        }
    }

    // MARK: - Keyboard Management

    private func setupKeyboardObservers() {
        // Klavye görünürlüğünü izle
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
            isKeyboardVisible = true
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            isKeyboardVisible = false
        }
    }

    // MARK: - View Components

    private var backgroundDecorations: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 300, height: 300)
                .offset(x: -150, y: -200)

            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 200, height: 200)
                .offset(x: 170, y: -250)

            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 400, height: 400)
                .offset(x: 150, y: 400)
        }
    }

    private var pageIndicator: some View {
        HStack {
            ForEach(0..<pages.count + 3, id: \.self) { index in
                Capsule()
                    .fill(Color.white.opacity(currentPage == index ? 1.0 : 0.4))
                    .frame(width: currentPage == index ? 20 : 7, height: 7)
                    .animation(.easeInOut, value: currentPage)
            }
        }
        .padding(.top, 30)
    }

    // Tanıtım sayfaları
    private var introPages: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: pages[currentPage].imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .foregroundColor(.white)
                .padding()
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 200, height: 200)
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 3)
                        .frame(width: 220, height: 220)
                )

            Text(pages[currentPage].title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 30)

            Text(pages[currentPage].description)
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 10)

            Spacer()

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

    // Kullanıcı bilgileri sayfası
    private var userInfoPage: some View {
        VStack(spacing: 25) {
            // Başlık
            Text("Sizi Tanıyalım")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.top, isKeyboardVisible ? 0 : 50)

            if !isKeyboardVisible {
                LottieView(name: "user_profile")
                    .frame(width: 150, height: 150)
            }

            // İsim alanı
            VStack(alignment: .leading, spacing: 10) {
                Text("İsminiz")
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

            // Yaş seçici
            VStack(alignment: .leading, spacing: 10) {
                Text("Yaşınız")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(.white)

                HStack {
                    Slider(value: Binding(
                        get: { Double(age) },
                        set: { age = Int($0) }
                    ), in: 18...100, step: 1)
                    .accentColor(.white)

                    Text("\(age)")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 40)
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(15)
            }
            .padding(.horizontal, 30)

            Spacer()

            // İleri butonu
            Button(action: {
                withAnimation {
                    currentPage += 1
                }
            }) {
                HStack {
                    Text("İleri")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(pages.first?.backgroundColor ?? .blue)

                    Image(systemName: "arrow.right")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(pages.first?.backgroundColor ?? .blue)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
            .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .opacity(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1)
        }
    }

    // Hedefler sayfası
    private var goalsPage: some View {
        VStack(spacing: 25) {
            // Başlık
            Text("Hedefleriniz")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.top, 50)

            Text("WellnessAI ile neyi başarmak istiyorsunuz?")
                .font(.system(size: 17))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            // Hedefler listesi
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(wellnessGoals, id: \.self) { goal in
                        GoalSelectionButton(
                            title: goal,
                            isSelected: selectedGoals.contains(goal),
                            action: {
                                toggleGoal(goal)
                            }
                        )
                    }
                }
                .padding(.horizontal, 30)
            }

            // Stres seviyesi
            VStack(alignment: .leading, spacing: 10) {
                Text("Günlük stres seviyeniz:")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(.white)

                HStack {
                    Text("Düşük")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))

                    Slider(value: Binding(
                        get: { Double(stressLevel) },
                        set: { stressLevel = Int($0) }
                    ), in: 1...5, step: 1)
                    .accentColor(.white)

                    Text("Yüksek")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                }

                // Stres seviyesi görselleştirme
                HStack {
                    ForEach(1...5, id: \.self) { level in
                        Circle()
                            .fill(level <= stressLevel ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 25, height: 25)
                            .overlay(
                                Text("\(level)")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(level <= stressLevel ? pages[1].backgroundColor : .white.opacity(0.5))
                            )
                    }
                }
                .padding(.top, 5)
            }
            .padding(.horizontal, 30)

            Spacer()

            // İleri butonu
            Button(action: {
                withAnimation {
                    currentPage += 1
                }
            }) {
                HStack {
                    Text("İleri")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(pages.first?.backgroundColor ?? .blue)

                    Image(systemName: "arrow.right")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(pages.first?.backgroundColor ?? .blue)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
            .disabled(selectedGoals.isEmpty)
            .opacity(selectedGoals.isEmpty ? 0.6 : 1)
        }
    }

    // Zorluklar sayfası
    private var challengesPage: some View {
        VStack(spacing: 25) {
            // Başlık
            Text("Zorluklarınız")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.top, 50)

            Text("Hangi alanlarda destek almak istiyorsunuz?")
                .font(.system(size: 17))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            // Zorluklar listesi
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(challenges, id: \.self) { challenge in
                        GoalSelectionButton(
                            title: challenge,
                            isSelected: selectedChallenges.contains(challenge),
                            action: {
                                toggleChallenge(challenge)
                            }
                        )
                    }
                }
                .padding(.horizontal, 30)
            }

            Spacer()

            // Başla butonu
            Button(action: {
                createUserAndStart()
            }) {
                HStack {
                    Text("Wellness Yolculuğuna Başla")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(pages.last?.backgroundColor ?? .green)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
            .disabled(selectedChallenges.isEmpty)
            .opacity(selectedChallenges.isEmpty ? 0.6 : 1)
        }
    }

    // MARK: - Helper Methods

    // Hedef seçimi toggle
    private func toggleGoal(_ goal: String) {
        if selectedGoals.contains(goal) {
            selectedGoals.removeAll { $0 == goal }
        } else {
            selectedGoals.append(goal)
        }
    }

    // Zorluk seçimi toggle
    private func toggleChallenge(_ challenge: String) {
        if selectedChallenges.contains(challenge) {
            selectedChallenges.removeAll { $0 == challenge }
        } else {
            selectedChallenges.append(challenge)
        }
    }

    // Kullanıcı oluştur ve başla
    private func createUserAndStart() {
        // Kullanıcı bilgilerini kaydet
        let userInfo = """
        Yaş: \(age)
        Hedefler: \(selectedGoals.joined(separator: ", "))
        Stres Seviyesi: \(stressLevel)/5
        Zorluklar: \(selectedChallenges.joined(separator: ", "))
        """

        // Kullanıcıyı oluştur
        viewModel.createUser(name: name)

        // Kullanıcı bilgilerini kaydet (gerçekte bu bilgileri daha yapılandırılmış bir şekilde kaydedebilirsiniz)
        let infoMessage = Message(
            content: "Kullanıcı Bilgileri:\n\(userInfo)",
            isFromUser: false
        )
        viewModel.messages.append(infoMessage)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(WellnessViewModel())
    }
}