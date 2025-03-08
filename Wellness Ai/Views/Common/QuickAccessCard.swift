import SwiftUI

struct QuickAccessCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // İkon ve başlık
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.7)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
            }

            Text(description)
                .font(.system(size: 14))
                .foregroundColor(.secondary)

            Spacer()

            // Devam et ikonu
            HStack {
                Spacer()

                Image(systemName: "chevron.right.circle.fill")
                    .foregroundColor(color.opacity(0.7))
                    .font(.system(size: 22))
            }
        }
        .padding(15)
        .frame(height: 135)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: color.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}

struct QuickAccessCard_Previews: PreviewProvider {
    static var previews: some View {
        QuickAccessCard(
            icon: "message.fill",
            title: "Sohbet",
            description: "Asistanla konuş",
            color: .blue
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}