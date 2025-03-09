import SwiftUI

struct ChatView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @State private var showSuggestions = true
    @State private var scrollToBottom = false
    @FocusState private var isTextFieldFocused: Bool

    // Chat suggestions
    let chatSuggestions = [
        "I'm feeling a bit stressed today",
        "Do you have any meditation recommendations?",
        "Can you give me advice on positive thinking?",
        "What can I do to sleep better?"
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // Chat header
                chatHeader

                // Chat messages
                chatMessagesView
            }

            // Message input area - above tab bar
            VStack(spacing: 0) {
                // Chat suggestions
                chatSuggestionsView

                // Input bar
                messageInputBar
            }
            .padding(.bottom, 80) // Space for tab bar
        }
        .onTapGesture {
            isTextFieldFocused = false
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }

    // MARK: - Component Views

    private var chatHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Wellness Assistant")
                    .font(.system(size: 20, weight: .bold, design: .rounded))

                Text("Always by your side")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Updated avatar to use the 512.png image
            Image("512")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 45, height: 45)
                .clipShape(Circle())
        }
        .padding()
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
    }

    private var chatMessagesView: some View {
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

    private var chatSuggestionsView: some View {
        Group {
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
        }
    }

    private var messageInputBar: some View {
        HStack(spacing: 15) {
            // Text field
            ZStack(alignment: .trailing) {
                TextField("Type your message...", text: $viewModel.currentInput)
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

                // Emoji/GIF button
                if viewModel.currentInput.isEmpty {
                    Button(action: {
                        // Emoji keyboard
                    }) {
                        Image(systemName: "face.smiling")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .padding(.trailing, 15)
                    }
                }
            }

            // Send button
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
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .environmentObject(WellnessViewModel())
    }
}
