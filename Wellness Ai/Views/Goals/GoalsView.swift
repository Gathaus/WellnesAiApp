import SwiftUI

struct GoalsView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @State private var showNewGoalSheet = false

    var body: some View {
        VStack(spacing: 0) {
            // Başlık ve yeni hedef butonu
            HStack {
                Text("Hedeflerim")
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

            // Tamamlanmayan hedefler
            VStack(alignment: .leading, spacing: 15) {
                Text("Devam Edenler")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .padding(.horizontal)

                if incompleteGoals.isEmpty {
                    EmptyGoalView(message: "Henüz devam eden bir hedefin yok.\nYeni bir hedef eklemek için + butonuna tıkla.")
                } else {
                    ForEach(incompleteGoals) { goal in
                        GoalCard(goal: goal, onToggle: toggleGoal)
                    }
                }
            }
            .padding(.bottom, 20)

            // Tamamlanan hedefler
            VStack(alignment: .leading, spacing: 15) {
                Text("Tamamlananlar")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .padding(.horizontal)

                if completedGoals.isEmpty {
                    EmptyGoalView(message: "Henüz tamamlanmış bir hedefin yok.\nHedeflerini gerçekleştirdikçe burada görünecekler.")
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

    // Tamamlanmamış hedefler
    var incompleteGoals: [Goal] {
        viewModel.goals.filter { !$0.isCompleted }
    }

    // Tamamlanmış hedefler
    var completedGoals: [Goal] {
        viewModel.goals.filter { $0.isCompleted }
    }

    // Hedef durumunu değiştir
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