import SwiftUI

struct EmptyGoalView: View {
    let message: String

    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 40))
                .foregroundColor(.gray.opacity(0.5))

            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("InputBackground"))
        )
        .padding(.horizontal)
    }
}

struct EmptyGoalView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyGoalView(message: "Henüz devam eden bir hedefin yok.\nYeni bir hedef eklemek için + butonuna tıkla.")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}