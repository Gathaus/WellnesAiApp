import SwiftUI

struct GoalCard: View {
    let goal: Goal
    let onToggle: (Goal) -> Void

    var body: some View {
        HStack(spacing: 15) {
            // Tamamlandı göstergesi
            Button(action: {
                onToggle(goal)
            }) {
                ZStack {
                    Circle()
                        .stroke(goal.type.color, lineWidth: 2)
                        .frame(width: 26, height: 26)

                    if goal.isCompleted {
                        Circle()
                            .fill(goal.type.color)
                            .frame(width: 18, height: 18)
                    }
                }
            }

            // İkon
            ZStack {
                Circle()
                    .fill(goal.type.color.opacity(0.2))
                    .frame(width: 40, height: 40)

                Image(systemName: goal.type.icon)
                    .font(.system(size: 18))
                    .foregroundColor(goal.type.color)
            }

            // İçerik
            VStack(alignment: .leading, spacing: 3) {
                Text(goal.title)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .strikethrough(goal.isCompleted, color: .secondary)
                    .foregroundColor(goal.isCompleted ? .secondary : .primary)

                if let targetDate = goal.targetDate {
                    Text("Hedef: \(formatDate(targetDate))")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("CardBackground"))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
}

struct GoalCard_Previews: PreviewProvider {
    static var previews: some View {
        GoalCard(
            goal: Goal(
                title: "Her gün 10 dakika meditasyon",
                type: .meditation,
                targetDate: Date().addingTimeInterval(60*60*24*7)
            ),
            onToggle: { _ in }
        )
        .previewLayout(.sizeThatFits)
        .padding(.vertical)
    }
}