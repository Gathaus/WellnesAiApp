import SwiftUI

struct MoodColumnView: View {
    let entry: MoodHistoryEntry
    let columnWidth: CGFloat

    var body: some View {
        VStack {
            Text(entry.mood.emoji)
                .font(.system(size: 20))
                .shadow(color: .gray.opacity(0.3), radius: 1, x: 1, y: 1)

            RoundedRectangle(cornerRadius: 10)
                .fill(moodGradient(for: entry.mood))
                .frame(width: columnWidth, height: CGFloat(entry.mood.value) * 25)

            Text(formatDate(entry.date))
                .font(.system(size: 10))
                .foregroundColor(.secondary)
        }
    }

    private func moodGradient(for mood: MoodType) -> LinearGradient {
        let color = moodColor(mood)
        return LinearGradient(
            gradient: Gradient(colors: [color.opacity(0.7), color]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private func moodColor(_ mood: MoodType) -> Color {
        switch mood {
        case .fantastic: return .green
        case .good: return .blue
        case .neutral: return .yellow
        case .bad: return .orange
        case .awful: return .red
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        return formatter.string(from: date)
    }
}

struct MoodColumnView_Previews: PreviewProvider {
    static var previews: some View {
        MoodColumnView(
            entry: MoodHistoryEntry(mood: .good, date: Date()),
            columnWidth: 40
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}