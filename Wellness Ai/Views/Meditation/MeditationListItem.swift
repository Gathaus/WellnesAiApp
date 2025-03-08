import SwiftUI

struct MeditationListItem: View {
    let meditation: Meditation

    var body: some View {
        NavigationLink(destination: MeditationDetailView(meditation: meditation)) {
            HStack(spacing: 15) {
                // İkon
                typeIconView

                // İçerik
                contentView

                Spacer()

                // Süre
                durationView
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
        }
    }

    private var typeIconView: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [meditation.type.color.opacity(0.8), meditation.type.color]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 50, height: 50)
                .shadow(color: meditation.type.color.opacity(0.2), radius: 5, x: 0, y: 3)

            Image(systemName: meditation.imageName)
                .font(.system(size: 22))
                .foregroundColor(.white)
        }
    }

    private var contentView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(meditation.title)
                .font(.system(size: 16, weight: .medium, design: .rounded))

            Text(meditation.description)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
    }

    private var durationView: some View {
        Text("\(meditation.duration) dk")
            .font(.system(size: 14, weight: .medium, design: .rounded))
            .foregroundColor(meditation.type.color)
    }
}

struct MeditationListItem_Previews: PreviewProvider {
    static var previews: some View {
        MeditationListItem(
            meditation: Meditation(
                title: "Derin Odak",
                description: "Çalışma öncesi konsantrasyonu artıran meditasyon",
                duration: 10,
                type: .focus,
                imageName: "lightbulb.fill"
            )
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}