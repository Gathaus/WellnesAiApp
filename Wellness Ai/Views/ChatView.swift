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
        "Olumlu düşünmek için tavsiye verir misin?",
        "Daha iyi uyumak için ne yapabilirim?"
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
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
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.blue.opacity(0.7), .purple.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 45, height: 45)
                        
                        Text("🧠")
                            .font(.system(size: 22))
                    }
                }
                .padding()
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                
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
                    .background(Color(.systemGray6))
                }
            }
            
            // Mesaj gönderme alanı - bottom bar üzerinde ama tab bar'ın üstünde
            VStack(spacing: 0) {
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
                                        .foregroundColor(.blue)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 60)
                    .background(
                        Color.white
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -3)
                    )
                }
                
                // Input bar
                HStack(spacing: 15) {
                    // Metin alanı
                    ZStack(alignment: .trailing) {
                        TextField("Mesajınızı yazın...", text: $viewModel.currentInput)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(25)
                            .focused($isTextFieldFocused)
                            .onChange(of: viewModel.currentInput) { _ in
                                if !viewModel.currentInput.isEmpty {
                                    showSuggestions = false
                                }
                            }
                        
                        // Emojiler/GIF butonu ekledik
                        if viewModel.currentInput.isEmpty {
                            Button(action: {
                                // Emoji klavyesi
                            }) {
                                Image(systemName: "face.smiling")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 15)
                            }
                        }
                    }
                    
                    // Gönder butonu
                    Button(action: {
                        if !viewModel.currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            viewModel.sendMessage(viewModel.currentInput)
                            isTextFieldFocused = false
                        }
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 35))
                            .foregroundColor(
                                viewModel.currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
                                .gray.opacity(0.6) : .blue
                            )
                    }
                    .disabled(viewModel.currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
            }
            .padding(.bottom, 80) // Tab bar için boşluk bırak
        }
        .onTapGesture {
            isTextFieldFocused = false
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

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
                            Text("👤")
                                .font(.system(size: 14))
                        )
                }
            } else {
                // Asistan avatarı
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
                            Text("🧠")
                                .font(.system(size: 14))
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
