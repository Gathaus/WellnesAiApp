import SwiftUI

struct NewGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var selectedType: GoalType = .meditation
    @State private var hasTargetDate = false
    @State private var targetDate = Date().addingTimeInterval(60*60*24*7) // One week ahead

    let onAdd: (Goal) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("What's your goal?", text: $title)

                    Picker("Category", selection: $selectedType) {
                        ForEach(GoalType.allCases) { type in
                            HStack {
                                Image(systemName: type.icon)
                                    .foregroundColor(type.color)
                                Text(type.rawValue)
                            }
                            .tag(type)
                        }
                    }
                }

                Section(header: Text("Target Date")) {
                    Toggle("Set Target Date", isOn: $hasTargetDate)

                    if hasTargetDate {
                        DatePicker("Date", selection: $targetDate, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("New Goal")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Add") {
                    let newGoal = Goal(
                        title: title,
                        type: selectedType,
                        targetDate: hasTargetDate ? targetDate : nil
                    )
                    onAdd(newGoal)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(title.isEmpty)
            )
        }
    }
}

struct NewGoalView_Previews: PreviewProvider {
    static var previews: some View {
        NewGoalView { _ in }
    }
}
