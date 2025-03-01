import SwiftUI

struct ChatView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @State private var showSuggestions = true
    @State private var scrollToBottom = false
    @FocusState private var isTextFieldFocused: Bool
    
    // Sohbet önerileri
    let chatSuggestions = [
        "Bugün kendimi biraz stresli hissediyorum",
        "Meditasyon için önerin var mı?",
        "Olumlu düşünmek için öneriler verir misin?",
        "Uyku düzenimi nasıl iyileştirebilirim?"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Chat header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Wellness Asistanı")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    
                    Text("Her zaman yanında")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Asistan avatar
                ZStack {
                    Circle()
                        .fill(Color.accentColor.opacity(0.2))
                        .frame(width: 45, height: 45)
                    
                    Text("🧠")
                        .font(.system(size: 22))
                }
            }
            .padding()
            .background(Color("CardBackground"))
            
            // Chat mesajları
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.messages) { message in
                            MessageView(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom, showSuggestions ? 90 : 10)
                    .id("messageEnd")
                }
                .onChange(of: viewModel.messages.count) { _ in
                    scrollToBottom = true
                }
                .onChange(of: scrollToBottom) { _ in
                    if scrollToBottom {
                        withAnimation {
                            scrollView.scrollTo("messageEnd", anchor: .bottom)
                        }
                        scrollToBottom = false
                    }
                }
                .background(Color("BackgroundColor"))
                
                // Sohbet önerileri
                if showSuggestions && !viewModel.messages.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(chatSuggestions, id: \.self) { suggestion in
                                Button {
                                    viewModel.sendMessage(suggestion)
                                    showSuggestions = false
                                } label: {
                                    Text(suggestion)
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(.accentColor)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(Color.accentColor.opacity(0.1))
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 60)
                    .background(
                        Color("CardBackground")
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -3)
                    )
                }
            }
            
            // Mesaj gönderme alanı
            HStack(spacing: 15) {
                TextField("Mesajınızı yazın...", text: $viewModel.currentInput)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(Color("InputBackground"))
                    .cornerRadius(25)
                    .focused($isTextFieldFocused)
                    .onChange(of: viewModel.currentInput) { _ in
                        if !viewModel.currentInput.isEmpty {
                            showSuggestions = false
                        }
                    }
                
                Button(action: {
                    if !viewModel.currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        viewModel.sendMessage(viewModel.currentInput)
                        isTextFieldFocused = false
                    }
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.accentColor)
                }
                .disabled(viewModel.currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color("CardBackground"))
        }
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
}

struct MessageView: View {
    let message: Message
    @State private var showTime = false
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(message.content)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(ChatBubble(isFromUser: true))
                    
                    if showTime {
                        Text(formatMessageTime(message.timestamp))
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .padding(.trailing, 8)
                    }
                }
            } else {
                VStack(alignment: .leading, spacing: 2) {
                    Text(message.content)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(Color("MessageBubbleBackground"))
                        .foregroundColor(.primary)
                        .clipShape(ChatBubble(isFromUser: false))
                    
                    if showTime {
                        Text(formatMessageTime(message.timestamp))
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .padding(.leading, 8)
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
    }
    
    private func formatMessageTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

struct ChatBubble: Shape {
    var isFromUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [
                .topLeft,
                .topRight,
                isFromUser ? .bottomLeft : .bottomRight
            ],
            cornerRadii: CGSize(width: 15, height: 15)
        )
        return Path(path.cgPath)
    }
}
