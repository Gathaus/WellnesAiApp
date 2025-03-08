import SwiftUI

struct ChatBubble: Shape {
    let isFromUser: Bool

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [
                .topLeft: !isFromUser,
                .topRight: true,
                .bottomLeft: true,
                .bottomRight: isFromUser
            ],
            cornerRadii: CGSize(width: 15, height: 15)
        )

        return Path(path.cgPath)
    }
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatBubble(isFromUser: true)
                .frame(width: 200, height: 100)
                .previewLayout(.sizeThatFits)
                .padding()
                .foregroundColor(.blue)

            ChatBubble(isFromUser: false)
                .frame(width: 200, height: 100)
                .previewLayout(.sizeThatFits)
                .padding()
                .foregroundColor(.gray)
        }
    }
}