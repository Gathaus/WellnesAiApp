import SwiftUI

struct CategoryButton: View {
    let type: MeditationType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                // Buton arkaplanı
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [type.color, type.color.opacity(0.7)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 65, height: 65)
                            .shadow(color: type.color.opacity(0.3), radius: 10, x: 0, y: 5)
                    } else {
                        Circle()
                            .fill(Color(.systemGray6))
                            .frame(width: 65, height: 65)
                    }
                    
                    // İkon
                    Image(systemName: type.icon)
                        .font(.system(size: 24))
                        .foregroundColor(isSelected ? .white : .gray)
                }
                
                // Kategori adı
                Text(type.rawValue)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(isSelected ? type.color : .gray)
            }
        }
    }
}
