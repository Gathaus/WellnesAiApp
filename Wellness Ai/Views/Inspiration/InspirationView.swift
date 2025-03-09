import SwiftUI
import Combine

struct InspirationView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @State private var currentAffirmationIndex = 0
    @State private var affirmations: [String] = []
    @State private var dragOffset: CGFloat = 0
    @State private var opacity: Double = 1.0
    @State private var showShareOptions = false
    @State private var hasSwipedOnce = false
    @State private var showShareSheet = false
    @State private var showFavoritesSheet = false
    @State private var isLoading = true
    @State private var cancellables = Set<AnyCancellable>()

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

            if isLoading {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    
                    Text("Loading inspirations...")
                        .foregroundColor(.white)
                        .padding(.top, 20)
                }
            } else {
                // Main content
                VStack(spacing: 40) {
                    // Header
                    headerView

                    Spacer()

                    // Main affirmation view (no card)
                    affirmationView
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
                                            hasSwipedOnce = true
                                        }
                                    }
                                    withAnimation(.spring()) {
                                        dragOffset = 0
                                        opacity = 1.0
                                    }
                                }
                        )

                    Spacer()

                    // Instructions (only shown before first swipe)
                    if !hasSwipedOnce {
                        Text("Swipe up 👆 for new inspiration")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 15)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(20)
                            .padding(.bottom, 30)
                    }

                    // Action buttons
                    actionButtonsView
                        .padding(.bottom, 80) // Extra padding for tab bar
                }
                .padding()
            }
        }
        .onAppear {
            // Fetch affirmations from backend
            fetchAffirmations()
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [currentAffirmation])
        }
        .sheet(isPresented: $showFavoritesSheet) {
            FavoritedInspirationsView()
                .environmentObject(viewModel)
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
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Daily Inspiration")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("Positive thinking, positive life")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            Button(action: {
                showFavoritesSheet = true
            }) {
                Image(systemName: "bookmark.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
        }
        .padding(.top, 30)
    }

    private var affirmationView: some View {
        VStack(spacing: 30) {
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
    }

    private var actionButtonsView: some View {
        HStack(spacing: 25) {
            // Share button
            actionButton(icon: "square.and.arrow.up", action: {
                showShareSheet = true
            })

            // Favorite button
            let isFavorited = viewModel.isInspirationFavorited(currentAffirmation)
            actionButton(
                icon: isFavorited ? "heart.fill" : "heart",
                action: {
                    viewModel.toggleFavoriteInspiration(currentAffirmation)
                },
                color: isFavorited ? .red : .white
            )

            // Refresh button
            actionButton(icon: "arrow.clockwise", action: {
                withAnimation(.spring()) {
                    showNextAffirmation()
                    hasSwipedOnce = true
                }
            })
        }
    }

    private func actionButton(icon: String, action: @escaping () -> Void, color: Color = .white) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 50, height: 50)
                .background(Color.white.opacity(0.2))
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        }
    }

    // MARK: - Helper Methods

    private var currentAffirmation: String {
        guard !affirmations.isEmpty else { return "Today will be a great day!" }
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

    private func fetchAffirmations() {
        isLoading = true
        
        // First try to load form backend API
        guard let url = URL(string: "http://localhost:8080/api/affirmations") else {
            // Fallback to local data if URL is invalid
            loadLocalAffirmations()
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [AffirmationResponse].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching affirmations: \(error)")
                    loadLocalAffirmations()
                }
                isLoading = false
            }, receiveValue: { response in
                self.affirmations = response.map { $0.content }
                if !self.affirmations.isEmpty {
                    // Add the daily affirmation at the beginning if available
                    if !viewModel.dailyAffirmation.isEmpty && !self.affirmations.contains(viewModel.dailyAffirmation) {
                        self.affirmations.insert(viewModel.dailyAffirmation, at: 0)
                    }
                    
                    // Shuffle the rest for variety (except the first one)
                    if self.affirmations.count > 1 {
                        let firstAffirmation = self.affirmations.first!
                        self.affirmations.removeFirst()
                        self.affirmations.shuffle()
                        self.affirmations.insert(firstAffirmation, at: 0)
                    }
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    private func loadLocalAffirmations() {
        // Fallback to local data
        affirmations = [
            "I am valuable and deserve to be loved.",
            "Every day, in every way, I am getting better and stronger.",
            "I have the power to overcome challenges.",
            "I can change my life in a positive way.",
            "I am good enough and I accept myself as I am.",
            "I feel grateful for today and every day.",
            "I have the power to create my own happiness.",
            "I radiate positive energy and attract positive energy.",
            "I am at peace.",
            "I love myself more each day.",
            "I am the architect of my life and make positive choices.",
            "I am fully present here and now, enjoying the moment.",
            "My worth is determined by who I am, not by my achievements.",
            "I approach myself with compassion and understanding.",
            "Every challenge strengthens and grows me.",
            "With each breath, I become calmer and more balanced.",
            "I respect my body and take good care of it.",
            "Meeting my own needs is not selfish, it's self-care.",
            "My life is full of beauty and opportunities.",
            "I have the freedom to choose at every moment, every day.",
            "I have the courage to change what I cannot accept, the serenity to accept what I cannot change, and the wisdom to know the difference."
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
        
        isLoading = false
    }
}

// Model for API response
struct AffirmationResponse: Codable {
    let id: String
    let content: String
    let createdAt: Date
}
