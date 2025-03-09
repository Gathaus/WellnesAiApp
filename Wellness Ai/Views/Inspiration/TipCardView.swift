import SwiftUI

struct TipCardView: View {
    let tip: WellnessTip
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Category and icon
            HStack {
                Text(tip.category.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(categoryColor.opacity(0.2))
                    .foregroundColor(categoryColor)
                    .cornerRadius(10)

                Spacer()

                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            }

            // Tip content
            Text(tip.content)
                .font(.system(size: 16))
                .lineLimit(isExpanded ? nil : 2)

            // Share buttons, only show when expanded
            if isExpanded {
                HStack(spacing: 15) {
                    Button(action: {
                        // Copy to clipboard
                        UIPasteboard.general.string = tip.content
                    }) {
                        Label("Kopyala", systemImage: "doc.on.doc")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }

                    Button(action: {
                        // Share
                    }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 5)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("CardBackground"))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }

    // Category color
    private var categoryColor: Color {
        switch tip.category {
        case .motivation:
            return .blue
        case .mindfulness:
            return .green
        case .selfCare:
            return .purple
        case .positivity:
            return .orange
        }
    }
}

struct TipCardView_Previews: PreviewProvider {
    static var previews: some View {
        TipCardView(
            tip: WellnessTip(
                content: "Focus on one goal each day. Small steps lead to big results.",
                category: .motivation
            )
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}