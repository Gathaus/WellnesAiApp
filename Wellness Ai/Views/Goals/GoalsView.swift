import SwiftUI

struct GoalsView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @State private var showNewGoalSheet = false

    var body: some View {
        VStack(spacing: 0) {
            // Title and new goal button
            HStack {
                Text("My Goals")
                    .font(.system(size: 28, weight: .bold, design: .rounded))

                Spacer()

                Button(action: {
                    showNewGoalSheet = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.accentColor)
                }
            }
            .padding()

            // Incomplete goals
            VStack(alignment: .leading, spacing: 15) {
                Text("In Progress")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .padding(.horizontal)

                if incompleteGoals.isEmpty {
                    EmptyGoalView(message: "You don't have any goals in progress.\nTap the + button to add a new goal.")
                } else {
                    ForEach(incompleteGoals) { goal in
                        GoalCard(goal: goal, onToggle: toggleGoal)
                    }
                }
            }
            .padding(.bottom, 20)

            // Completed goals
            VStack(alignment: .leading, spacing: 15) {
                Text("Completed")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .padding(.horizontal)

                if completedGoals.isEmpty {
                    EmptyGoalView(message: "You haven't completed any goals yet.\nThey will appear here when you complete them.")
                } else {
                    ForEach(completedGoals) { goal in
                        GoalCard(goal: goal, onToggle: toggleGoal)
                    }
                }
            }

            Spacer()
        }
        .background(Color("BackgroundColor"))
        .sheet(isPresented: $showNewGoalSheet) {
            NewGoalView { newGoal in
                viewModel.addGoal(newGoal)
            }
        }
    }

    // Incomplete goals
    var incompleteGoals: [Goal] {
        viewModel.goals.filter { !$0.isCompleted }
    }

    // Completed goals
    var completedGoals: [Goal] {
        viewModel.goals.filter { $0.isCompleted }
    }

    // Toggle goal status
    func toggleGoal(_ goal: Goal) {
        viewModel.toggleGoalCompletion(goal)
    }
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsView()
            .environmentObject(WellnessViewModel())
    }
}
