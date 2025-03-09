import SwiftUI

struct MeditationCard: View {
    let meditation: Meditation

    var body: some View {
        NavigationLink(destination: MeditationDetailView(meditation: meditation)) {
            ZStack(alignment: .bottom) {
                // Arka plan
                RoundedRectangle(cornerRadius: 20)
                    .fill(cardGradient)
                    .shadow(color: meditation.type.color.opacity(0.3), radius: 10, x: 0, y: 5)

                // Content
                cardContent
            }
        }
    }

    private var cardGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [meditation.type.color.opacity(0.8), meditation.type.color]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Top section - icon and duration
            HStack {
                Image(systemName: meditation.imageName)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())

                Spacer()

                Text("\(meditation.duration) dakika")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(15)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            Spacer()

            // Bottom section - title and description
            VStack(alignment: .leading, spacing: 5) {
                Text(meditation.title)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text(meditation.description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(2)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

struct MeditationCard_Previews: PreviewProvider {
    static var previews: some View {
        MeditationCard(
            meditation: Meditation(
                title: "Sabah Odaklanma",
                description: "Short meditation to start the day energized",
                duration: 5,
                type: .focus,
                imageName: "sunrise.fill"
            )
        )
        .frame(width: 280, height: 180)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}