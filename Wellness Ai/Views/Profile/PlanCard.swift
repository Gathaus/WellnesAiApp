import SwiftUI

struct PlanCard: View {
    let plan: SubscriptionPlan
    @Binding var selectedPlan: SubscriptionPlan
    let title: String
    let price: String
    let description: String
    let savings: String

    var body: some View {
        Button(action: {
            selectedPlan = plan
        }) {
            HStack {
                // Seçim göstergesi
                ZStack {
                    Circle()
                        .stroke(Color.accentColor, lineWidth: 2)
                        .frame(width: 24, height: 24)

                    if selectedPlan == plan {
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 16, height: 16)
                    }
                }

                // Plan bilgileri
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))

                    Text(description)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Fiyat
                VStack(alignment: .trailing, spacing: 3) {
                    Text(price)
                        .font(.system(size: 18, weight: .bold, design: .rounded))

                    if !savings.isEmpty {
                        Text(savings)
                            .font(.system(size: 10))
                            .foregroundColor(.green)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(selectedPlan == plan ? Color.accentColor.opacity(0.1) : Color("InputBackground"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(selectedPlan == plan ? Color.accentColor : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PlanCard_Previews: PreviewProvider {
    static var previews: some View {
        PlanCard(
            plan: .monthly,
            selectedPlan: .constant(.monthly),
            title: "Aylık",
            price: "₺39,99",
            description: "Her ay otomatik yenilenir",
            savings: ""
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}