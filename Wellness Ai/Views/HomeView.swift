import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @State private var currentMood: MoodType = .neutral
    @State private var showCopiedMessage = false
    @State private var showNotifications = false
    @State private var showShareSheet = false
    @Binding var selectedTab: Int

    let sampleNotifications = [
        "Don't forget to do your daily meditation!",
        "You've reached 50% of your water drinking goal for today.",
        "A new inspiration quote is ready, check it out!"
    ]

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 25) {
                    // Top greeting card
                    greetingCard

                    // Today's mood card
                    moodSelectionCard

                    // Daily positive message card
                    dailyAffirmationCard

                    // Quick access cards
                    quickAccessCardsSection

                    // Mood history
                    moodHistorySection
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            .background(Color(.systemGray6).ignoresSafeArea())
            .navigationBarTitle("WellnessAI", displayMode: .large)
            .navigationBarItems(trailing:
                Button(action: {
                    withAnimation(.spring()) {
                        showNotifications.toggle()
                    }
                }) {
                    Image(systemName: "bell")
                        .font(.system(size: 18))
                        .foregroundColor(.primary)
                        .overlay(
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                                .offset(x: 7, y: -7)
                                .opacity(showNotifications ? 0 : 1)
                        )
                }
            )

            // Notification overlay
            if showNotifications {
                notificationsOverlay
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [viewModel.dailyAffirmation])
        }
    }

    // MARK: - Component Views
    private var greetingCard: some View {
        HStack {
            HStack(spacing: 5) {
                Text("Hello,")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)

                if let user = viewModel.user {
                    Text(user.name)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
            }

            Spacer()

            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 50, height: 50)

                Text("✨")
                    .font(.system(size: 25))
            }
        }
        .padding(.top, 10)
    }

    private var moodSelectionCard: some View {
        VStack(spacing: 15) {
            Text("How are you feeling today?")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)

            moodButtonsRow
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }

    private var moodButtonsRow: some View {
        HStack(spacing: 20) {
            // Reversed order: awful to fantastic
            moodButton(for: MoodType.awful)
            moodButton(for: MoodType.bad)
            moodButton(for: MoodType.neutral)
            moodButton(for: MoodType.good)
            moodButton(for: MoodType.fantastic)
        }
    }

    private func moodButton(for mood: MoodType) -> some View {
        Button(action: {
            withAnimation {
                currentMood = mood
                viewModel.logMood(mood)
            }
        }) {
            VStack {
                moodEmojiView(for: mood)

                Text(mood.rawValue)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(currentMood == mood ? .primary : .secondary)
            }
        }
    }

    private func moodEmojiView(for mood: MoodType) -> some View {
        Text(mood.emoji)
            .font(.system(size: 30))
            .shadow(color: .gray.opacity(0.3), radius: 2, x: 1, y: 1)
            .padding(8)
            .background(
                Circle()
                    .fill(moodCircleGradient(for: mood))
                    .frame(width: 60, height: 60)
            )
    }

    private func moodCircleGradient(for mood: MoodType) -> LinearGradient {
        if currentMood == mood {
            return LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.6), .purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    private var dailyAffirmationCard: some View {
        VStack(spacing: 20) {
            HStack {
                Text("📝 Daily Inspiration")
                    .font(.system(size: 22, weight: .bold, design: .rounded))

                Spacer()
            }

            Text(viewModel.dailyAffirmation)
                .font(.system(size: 20, weight: .medium, design: .serif))
                .italic()
                .multilineTextAlignment(.center)
                .padding(.vertical, 15)
                .lineSpacing(8)
                .foregroundColor(.black.opacity(0.8))

            // Copied message overlay
            ZStack {
                // Social sharing buttons
                HStack(spacing: 15) {
                    shareButtonView(text: "Copy", icon: "doc.on.doc.fill", color: .blue) {
                        UIPasteboard.general.string = viewModel.dailyAffirmation
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showCopiedMessage = true
                        }
                        // Hide the message after a delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showCopiedMessage = false
                            }
                        }
                    }

                    shareButtonView(text: "Share", icon: "square.and.arrow.up.fill", color: .green) {
                        showShareSheet = true
                    }
                }
                .opacity(showCopiedMessage ? 0 : 1)

                // "Copied" message
                if showCopiedMessage {
                    Text("Copied ✓")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.green)
                        .cornerRadius(20)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .padding(25)
        .background(
            affirmationCardBackground
        )
    }

    private var affirmationCardBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.1)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            // Decorative elements in background
            Circle()
                .fill(Color.purple.opacity(0.1))
                .frame(width: 100, height: 100)
                .offset(x: -120, y: -60)

            Circle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 60, height: 60)
                .offset(x: 130, y: 70)
        }
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }

    private func shareButtonView(text: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14))

                Text(text)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(20)
        }
    }

    private var quickAccessCardsSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            chatCardView
            meditationCardView
            inspirationCardView
        }
    }

    private var chatCardView: some View {
        Button(action: {
            selectedTab = 2 // Switch to chat tab
        }) {
            QuickAccessCard(
                icon: "message.fill",
                title: "Chat",
                description: "Talk with your assistant",
                color: .blue
            )
        }
    }

    private var meditationCardView: some View {
        Button(action: {
            selectedTab = 1 // Switch to meditation tab
        }) {
            QuickAccessCard(
                icon: "lungs.fill",
                title: "Meditation",
                description: "Find inner peace",
                color: .purple
            )
        }
    }

    private var inspirationCardView: some View {
        Button(action: {
            selectedTab = 3 // Switch to inspiration tab
        }) {
            QuickAccessCard(
                icon: "lightbulb.fill",
                title: "Inspiration",
                description: "Daily motivation",
                color: .orange
            )
        }
    }

    private var moodHistorySection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Last 7 Days - Mood Tracking")
                .font(.system(size: 18, weight: .bold, design: .rounded))

            MoodHistoryChart(moodHistory: viewModel.moodHistory)
                .frame(height: 200)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }

    // Notification Overlay
    private var notificationsOverlay: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Notifications")
                        .font(.system(size: 18, weight: .bold, design: .rounded))

                    Spacer()

                    Button(action: {
                        withAnimation(.spring()) {
                            showNotifications = false
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 22))
                    }
                }
                .padding()

                Divider()

                if sampleNotifications.isEmpty {
                    VStack {
                        Text("No notifications")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .padding(.vertical, 30)
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(sampleNotifications, id: \.self) { notification in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(notification)
                                        .font(.system(size: 16))

                                    Text("Just now")
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)

                                Divider()
                            }
                        }
                    }
                    .frame(maxHeight: 300)
                }
            }
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            .padding(.horizontal)
            .transition(.move(edge: .top).combined(with: .opacity))

            Spacer()
        }
        .padding(.top, 10)
        .background(
            Color.black.opacity(0.2)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring()) {
                        showNotifications = false
                    }
                }
        )
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView(selectedTab: .constant(0))
                .environmentObject(WellnessViewModel())
        }
    }
}
