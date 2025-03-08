import SwiftUI

struct InspirationView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @State private var selectedCategory: TipCategory? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                headerView

                // Category filter
                categoryFilterView

                // Daily affirmation card
                dailyAffirmationCard

                // Tips list
                tipsListView

                // Bottom spacing for tab bar
                Spacer()
                    .frame(height: 80)
            }
            .padding(.horizontal)
        }
        .background(Color("BackgroundColor").ignoresSafeArea())
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }

    // MARK: - Component Views

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("İlham Köşesi")
                .font(.system(size: 28, weight: .bold, design: .rounded))

            Text("Günlük ipuçları ve pozitif mesajlar")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 20)
    }

    private var categoryFilterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                // All categories button
                CategoryFilterButton(
                    title: "Tümü",
                    isSelected: selectedCategory == nil,
                    action: { selectedCategory = nil }
                )

                // Category buttons
                ForEach(TipCategory.allCases) { category in
                    CategoryFilterButton(
                        title: category.rawValue,
                        isSelected: selectedCategory == category,
                        action: { selectedCategory = category }
                    )
                }
            }
            .padding(.vertical, 5)
        }
    }

    private var dailyAffirmationCard: some View {
        VStack(spacing: 15) {
            // Title
            HStack {
                Text("Günün Olumlaması")
                    .font(.system(size: 18, weight: .bold, design: .rounded))

                Spacer()

                // Refresh button
                Button(action: {
                    withAnimation {
                        viewModel.refreshDailyAffirmation()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 16))
                        .foregroundColor(.accentColor)
                }
            }

            // Affirmation text
            Text(viewModel.dailyAffirmation)
                .font(.system(size: 18, weight: .medium, design: .serif))
                .italic()
                .multilineTextAlignment(.center)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("CardBackground"))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }

    private var tipsListView: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Title
            Text("Wellness İpuçları")
                .font(.system(size: 18, weight: .bold, design: .rounded))

            // Filter results message
            if let category = selectedCategory {
                Text("\(category.rawValue) kategorisindeki ipuçları gösteriliyor")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }

            // Tips
            let filteredTips = viewModel.getFilteredTips(for: selectedCategory)
            ForEach(filteredTips) { tip in
                TipCardView(tip: tip)
            }

            // If no tips
            if filteredTips.isEmpty {
                Text("Bu kategoride henüz ipucu bulunmuyor.")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 30)
            }
        }
    }
}

struct InspirationView_Previews: PreviewProvider {
    static var previews: some View {
        InspirationView()
            .environmentObject(WellnessViewModel())
    }
}