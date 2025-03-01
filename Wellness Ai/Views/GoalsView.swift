import SwiftUI

struct GoalsView: View {
    @State private var goals: [Goal] = sampleGoals
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
                goals.append(newGoal)
            }
        }
    }
    
    // Tamamlanmamış hedefler
    var incompleteGoals: [Goal] {
        goals.filter { !$0.isCompleted }
    }
    
    // Tamamlanmış hedefler
    var completedGoals: [Goal] {
        goals.filter { $0.isCompleted }
    }
    
    // Hedef durumunu değiştir
    func toggleGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index].isCompleted.toggle()
        }
    }
}


// Örnek hedefler
let sampleGoals = [
    Goal(title: "Her gün 10 dakika meditasyon", type: .meditation, targetDate: Date().addingTimeInterval(60*60*24*7)),
    Goal(title: "Günde 2 litre su içmek", type: .water, targetDate: nil),
    Goal(title: "Haftada 3 gün egzersiz yapmak", type: .exercise, targetDate: Date().addingTimeInterval(60*60*24*30)),
    Goal(title: "Her gün günlük tutmak", type: .journal, targetDate: nil, isCompleted: true),
    Goal(title: "Farkındalık pratikleri yapmak", type: .mindfulness, targetDate: nil, isCompleted: true)
]

// Hedef kartı komponenti
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

// Boş hedef görünümü
struct EmptyGoalView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 40))
                .foregroundColor(.gray.opacity(0.5))
            
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("InputBackground"))
        )
        .padding(.horizontal)
    }
}

// Yeni hedef ekleme ekranı
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
