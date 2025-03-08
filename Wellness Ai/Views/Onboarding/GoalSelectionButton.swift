import SwiftUI

struct GoalSelectionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(isSelected ? .white : .black)

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .white : .gray)
                    .font(.system(size: 20))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color.blue.opacity(0.8) : Color.white)
            )
            .animation(.spring(), value: isSelected)
        }
    }
}

struct GoalSelectionButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            GoalSelectionButton(title: "Her gün 10 dakika meditasyon yapmak", isSelected: true, action: {})
            GoalSelectionButton(title: "Günde 2 litre su içmek", isSelected: false, action: {})
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}