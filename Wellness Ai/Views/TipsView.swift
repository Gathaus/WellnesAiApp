import SwiftUI

struct TipsView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @State private var selectedCategory: TipCategory? = nil
    
    var body: some View {
        VStack {
            // Kategori seçim butonları
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    CategoryButton(title: "Tümü", isSelected: selectedCategory == nil) {
                        selectedCategory = nil
                    }
                    
                    ForEach(TipCategory.allCases, id: \.self) { category in
                        CategoryButton(
                            title: category.rawValue,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 10)
            
            // İpuçları listesi
            List(viewModel.getFilteredTips(for : selectedCategory)) { tip in
                VStack(alignment: .leading, spacing: 8) {
                    Text(tip.category.rawValue)
                        .font(.caption)
                        .foregroundColor(categoryColor(for: tip.category))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(categoryColor(for: tip.category).opacity(0.2))
                        .cornerRadius(4)
                    
                    Text(tip.content)
                        .font(.body)
                }
                .padding(.vertical, 8)
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Wellness İpuçları")
    }
    
    private func categoryColor(for category: TipCategory) -> Color {
        switch category {
        case .motivation:
            return .red
        case .mindfulness:
            return .purple
        case .selfCare:
            return .pink
        case .positivity:
            return .yellow
        }
    }
}
