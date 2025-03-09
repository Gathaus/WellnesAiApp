import SwiftUI

struct GoalCard: View {
    let goal: Goal
    let onToggle: (Goal) -> Void

    var body: some View {
        HStack(spacing: 15) {
            // Completion indicator
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

            // Icon
            ZStack {
                Circle()
                    .fill(goal.type.color.opacity(0.2))
                    .frame(width: 40, height: 40)

                Image(systemName: goal.type.icon)
                    .font(.system(size: 18))
                    .foregroundColor(goal.type.color)
            }

            // Content
            VStack(alignment: .leading, spacing: 3) {
                Text(goal.title)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .strikethrough(goal.isCompleted, color: .secondary)
                    .foregroundColor(goal.isCompleted ? .secondary : .primary)

                if let targetDate = goal.targetDate {
                    Text("Target: \(formatDate(targetDate))")
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
        formatter.locale = Locale(identifier: "en_US") // Set locale to English
        return formatter.string(from: date)
    }
}

struct GoalCard_Previews: PreviewProvider {
    static var previews: some View {
        GoalCard(
            goal: Goal(
                title: "Meditate for 10 minutes daily",
                type: .meditation,
                targetDate: Date().addingTimeInterval(60*60*24*7)
            ),
            onToggle: { _ in }
        )
        .previewLayout(.sizeThatFits)
        .padding(.vertical)
    }
}
