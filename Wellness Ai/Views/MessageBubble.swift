import SwiftUI

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            } else {
                Text(message.content)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(15)
                Spacer()
            }
        }
    }
}
