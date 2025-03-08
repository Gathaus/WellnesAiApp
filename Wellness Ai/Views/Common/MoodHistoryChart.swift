import SwiftUI

struct MoodHistoryChart: View {
    let moodHistory: [MoodHistoryEntry]

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 0) {
                if !moodHistory.isEmpty {
                    // Calculate column width and spacing
                    let columns = min(moodHistory.count, 7)
                    let spacing: CGFloat = 8 // Reduced spacing
                    let availableWidth = geometry.size.width - (spacing * CGFloat(columns - 1))
                    let columnWidth = min(availableWidth / CGFloat(columns), 45) // Limit column width

                    // Create evenly spaced columns with proper padding
                    ForEach(0..<columns, id: \.self) { index in
                        if index < moodHistory.count {
                            let entry = moodHistory[index]
                            if index > 0 {
                                Spacer().frame(width: spacing)
                            }

                            MoodColumnView(
                                entry: entry,
                                columnWidth: columnWidth
                            )
                        }
                    }

                    // Add extra padding at the end to prevent cutoff
                    Spacer(minLength: 5)
                } else {
                    // Empty state
                    Text("Henüz ruh hali verisi yok")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

struct MoodHistoryChart_Previews: PreviewProvider {
    static var previews: some View {
        MoodHistoryChart(moodHistory: [
            MoodHistoryEntry(mood: .fantastic, date: Date()),
            MoodHistoryEntry(mood: .good, date: Date().addingTimeInterval(-86400)),
            MoodHistoryEntry(mood: .neutral, date: Date().addingTimeInterval(-172800)),
        ])
        .frame(height: 200)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}