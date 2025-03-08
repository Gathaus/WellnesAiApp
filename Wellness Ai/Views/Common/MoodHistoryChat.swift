import SwiftUI

struct MoodHistoryChart: View {
    let moodHistory: [MoodHistoryEntry]

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 0) {
                if !moodHistory.isEmpty {
                    // Instead of ForEach, use explicit views
                    let columns = min(moodHistory.count, 7)
                    let spacing: CGFloat = 10
                    let availableWidth = geometry.size.width - (spacing * CGFloat(columns - 1))
                    let columnWidth = availableWidth / CGFloat(columns)

                    // Generate column views
                    ForEach(0..<columns, id: \.self) { index in
                        if index < moodHistory.count {
                            let entry = moodHistory[index]
                            MoodColumnView(
                                entry: entry,
                                columnWidth: columnWidth
                            )
                            if index < columns - 1 {
                                Spacer().frame(width: spacing)
                            }
                        }
                    }
                } else {
                    // Empty state
                    Text("Henüz ruh hali verisi yok")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding(.horizontal)
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