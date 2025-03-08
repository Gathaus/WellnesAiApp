import SwiftUI

struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .bold : .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.accentColor : Color("InputBackground"))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

struct CategoryFilterButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CategoryFilterButton(title: "Tümü", isSelected: true, action: {})
            CategoryFilterButton(title: "Motivasyon", isSelected: false, action: {})
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}