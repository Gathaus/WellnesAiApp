import SwiftUI

struct InspirationView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @State private var currentAffirmationIndex = 0
    @State private var affirmations: [String] = []
    @State private var dragOffset: CGFloat = 0
    @State private var opacity: Double = 1.0
    @State private var showShareOptions = false

    // Different gradient configurations for variety
    let gradients: [LinearGradient] = [
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "8A2387"), Color(hex: "E94057"), Color(hex: "F27121")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "11998e"), Color(hex: "38ef7d")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "2193b0"), Color(hex: "6dd5ed")]),
            startPoint: .top,
            endPoint: .bottom
        ),
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "C33764"), Color(hex: "1D2671")]),
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        ),
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "FF416C"), Color(hex: "FF4B2B")]),
            startPoint: .top,
            endPoint: .bottom
        )
    ]

    var body: some View {
        ZStack {
            // Background gradient that changes with each affirmation
            gradients[currentAffirmationIndex % gradients.count]
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.7), value: currentAffirmationIndex)

            // Decorative elements
            decorativeElements

            // Main content
            VStack(spacing: 40) {
                // Header
                headerView

                Spacer()

                // Main affirmation card
                affirmationCardView
                    .offset(y: dragOffset)
                    .opacity(opacity)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.translation.height < 0 {
                                    // Only allow dragging upward
                                    dragOffset = value.translation.height / 3
                                    opacity = 1.0 + (dragOffset / 500)
                                }
                            }
                            .onEnded { value in
                                if value.translation.height < -100 {
                                    // Threshold to show next affirmation
                                    withAnimation(.spring()) {
                                        showNextAffirmation()
                                    }
                                }
                                withAnimation(.spring()) {
                                    dragOffset = 0
                                    opacity = 1.0
                                }
                            }
                    )

                Spacer()

                // Instructions
                Text("Yukarı kaydır 👆 yeni ilham sözü için")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 15)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(20)
                    .padding(.bottom, 30)

                // Action buttons
                actionButtonsView
                    .padding(.bottom, 80) // Extra padding for tab bar
            }
            .padding()

            // Share sheet
            if showShareOptions {
                shareOptionsView
            }
        }
        .onAppear {
            // Initialize affirmations
            loadAffirmations()
        }
    }

    // MARK: - Component Views

    private var decorativeElements: some View {
        ZStack {
            // Decorative circles
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 300, height: 300)
                .offset(x: -150, y: -200)

            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 200, height: 200)
                .offset(x: 150, y: -100)

            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 250, height: 250)
                .offset(x: 100, y: 300)
        }
    }

    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Günlük İlham")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            Text("Pozitif düşünce, pozitif yaşam")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.top, 30)
    }

    private var affirmationCardView: some View {
        VStack(spacing: 30) {
            // Decorative icon
            Image(systemName: "quote.bubble.fill")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.7))

            // Affirmation text
            Text(currentAffirmation)
                .font(.system(size: 26, weight: .medium, design: .serif))
                .italic()
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .fixedSize(horizontal: false, vertical: true)

            // Decorative icon
            Image(systemName: "sparkles")
                .font(.system(size: 30))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .padding(.horizontal, 25)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0.15))
                .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 10)
                .blur(radius: 0.5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }

    private var actionButtonsView: some View {
        HStack(spacing: 25) {
            // Share button
            actionButton(icon: "square.and.arrow.up", action: {
                showShareOptions = true
            })

            // Favorite button
            actionButton(icon: "heart", action: {
                // Add to favorites (could be implemented later)
            })

            // Refresh button
            actionButton(icon: "arrow.clockwise", action: {
                withAnimation(.spring()) {
                    showNextAffirmation()
                }
            })
        }
    }

    private func actionButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Color.white.opacity(0.2))
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        }
    }

    private var shareOptionsView: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        showShareOptions = false
                    }
                }

            // Share options panel
            VStack(spacing: 20) {
                Text("Paylaş")
                    .font(.system(size: 18, weight: .bold, design: .rounded))

                Divider()

                // Share options
                HStack(spacing: 30) {
                    shareOption(title: "Kopyala", icon: "doc.on.doc.fill") {
                        UIPasteboard.general.string = currentAffirmation
                        withAnimation {
                            showShareOptions = false
                        }
                    }

                    shareOption(title: "Mesaj", icon: "message.fill") {
                        // Share via message - this would normally integrate with UIActivityViewController
                        withAnimation {
                            showShareOptions = false
                        }
                    }

                    shareOption(title: "Sosyal", icon: "person.2.fill") {
                        // Share to social media - this would normally integrate with UIActivityViewController
                        withAnimation {
                            showShareOptions = false
                        }
                    }
                }

                Button("İptal") {
                    withAnimation {
                        showShareOptions = false
                    }
                }
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.primary)
                .padding(.vertical, 10)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("CardBackground"))
            )
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 40)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .animation(.spring(), value: showShareOptions)
        }
    }

    private func shareOption(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.accentColor)

                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
            }
            .frame(width: 70)
        }
    }

    // MARK: - Helper Methods

    private var currentAffirmation: String {
        guard !affirmations.isEmpty else { return "Bugün harika bir gün olacak!" }
        return affirmations[currentAffirmationIndex % affirmations.count]
    }

    private func showNextAffirmation() {
        withAnimation(.easeInOut) {
            opacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            currentAffirmationIndex += 1
            withAnimation(.easeInOut) {
                opacity = 1
            }
        }
    }

    private func loadAffirmations() {
        // Load all available affirmations
        affirmations = [
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

        // Add the daily affirmation at the beginning
        if !viewModel.dailyAffirmation.isEmpty {
            affirmations.insert(viewModel.dailyAffirmation, at: 0)
        }

        // Shuffle the rest for variety
        let firstAffirmation = affirmations.first
        affirmations.removeFirst()
        affirmations.shuffle()
        if let first = firstAffirmation {
            affirmations.insert(first, at: 0)
        }
    }
}

struct InspirationView_Previews: PreviewProvider {
    static var previews: some View {
        InspirationView()
            .environmentObject(WellnessViewModel())
    }
}