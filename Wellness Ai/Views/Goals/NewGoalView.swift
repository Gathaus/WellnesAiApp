import SwiftUI

struct NewGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var selectedType: GoalType = .meditation
    @State private var hasTargetDate = false
    @State private var targetDate = Date().addingTimeInterval(60*60*24*7) // Bir hafta sonrası

    let onAdd: (Goal) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Hedef Detayları")) {
                    TextField("Hedefin nedir?", text: $title)

                    Picker("Kategori", selection: $selectedType) {
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

                Section(header: Text("Hedef Tarih")) {
                    Toggle("Hedef Tarih Belirle", isOn: $hasTargetDate)

                    if hasTargetDate {
                        DatePicker("Tarih", selection: $targetDate, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("Yeni Hedef")
            .navigationBarItems(
                leading: Button("İptal") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Ekle") {
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