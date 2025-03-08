import SwiftUI

struct CategorySelectorView: View {
    @Binding var selectedCategory: MeditationType

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(MeditationType.allCases, id: \.self) { type in
                    CategoryButton(
                        type: type,
                        isSelected: selectedCategory == type,
                        action: {
                            withAnimation {
                                selectedCategory = type
                            }
                        }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
}

struct CategorySelectorView_Previews: PreviewProvider {
    static var previews: some View {
        CategorySelectorView(selectedCategory: .constant(.focus))
            .previewLayout(.sizeThatFits)
            .padding(.vertical)
    }
}