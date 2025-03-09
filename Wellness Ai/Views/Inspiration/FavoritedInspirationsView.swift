import SwiftUI

struct FavoritedInspirationsView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showShareSheet = false
    @State private var shareContent = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Favorite Inspirations")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            if viewModel.favoritedInspirations.isEmpty {
                // Empty state
                VStack(spacing: 20) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 60))
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("No Favorite Inspirations Yet")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    
                    Text("Tap the heart icon on any inspiration to add it to your favorites.")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxHeight: .infinity)
            } else {
                // List of favorited inspirations
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(viewModel.favoritedInspirations, id: \.self) { inspiration in
                            FavoritedInspirationCard(
                                inspiration: inspiration,
                                onUnfavorite: {
                                    viewModel.toggleFavoriteInspiration(inspiration)
                                },
                                onShare: {
                                    shareContent = inspiration
                                    showShareSheet = true
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [shareContent])
        }
    }
}

struct FavoritedInspirationCard: View {
    let inspiration: String
    let onUnfavorite: () -> Void
    let onShare: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Inspiration text
            Text(inspiration)
                .font(.system(size: 18, weight: .medium, design: .serif))
                .italic()
                .lineSpacing(4)
                .padding(.top, 10)
            
            // Actions
            HStack {
                Button(action: onShare) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Button(action: onUnfavorite) {
                    Label("Remove", systemImage: "heart.slash")
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}
