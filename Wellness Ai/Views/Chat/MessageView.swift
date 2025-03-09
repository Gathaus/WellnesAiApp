import SwiftUI

struct MessageView: View {
    let message: Message
    @State private var showTime = false

    var body: some View {
        HStack(alignment: .bottom) {
            if message.isFromUser {
                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(message.content)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundColor(.white)
                        .clipShape(ChatBubble(isFromUser: true))
                        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)

                    if showTime {
                        Text(formatMessageTime(message.timestamp))
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .padding(.trailing, 8)
                            .padding(.top, 2)
                    }
                }

                // Kullanıcı avatarı - opsiyonel
                if !showTime {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 28, height: 28)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        )
                }
            } else {
                // Updated friendly assistant avatar
                if !showTime {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue.opacity(0.7), .purple.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 28, height: 28)
                        .overlay(
                            Image(systemName: "face.smiling.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        )
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(message.content)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .foregroundColor(.primary)
                        .clipShape(ChatBubble(isFromUser: false))
                        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)

                    if showTime {
                        Text(formatMessageTime(message.timestamp))
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .padding(.leading, 8)
                            .padding(.top, 2)
                    }
                }

                Spacer()
            }
        }
        .onTapGesture {
            withAnimation {
                showTime.toggle()
            }
        }
        .padding(.horizontal, 4)
    }

        private func formatMessageTime(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }
    }

    struct MessageView_Previews: PreviewProvider {
        static var previews: some View {
            VStack(spacing: 20) {
                MessageView(message: Message(content: "Merhaba, nasılsın?", isFromUser: true))
                MessageView(message: Message(content: "I'm fine, thank you! How can I help you today?", isFromUser: false))
            }
            .padding()
            .previewLayout(.sizeThatFits)
        }
    }