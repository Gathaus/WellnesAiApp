import SwiftUI
import UIKit

struct ChatBubble: Shape {
    let isFromUser: Bool

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: isFromUser
                ? [.topLeft, .topRight, .bottomLeft]
                : [.topRight, .bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: 15, height: 15)
        )

        return Path(path.cgPath)
    }
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubble(isFromUser: true)
            .frame(width: 200, height: 50)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}