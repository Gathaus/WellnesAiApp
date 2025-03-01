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
                    Circle()
                        .fill(Color.white)
                        .frame(width: 65, height: 65)
                        .background(backgroundGradient)
                        .shadow(color: shadowColor, radius: 10, x: 0, y: 5)
                    
                    // İkon
                    Image(systemName: type.icon)
                        .font(.system(size: 24))
                        .foregroundColor(iconColor)
                }
                
                // Kategori adı
                Text(type.rawValue)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(textColor)
            }
        }
    }
    
    // Hesaplanmış özellikler
    private var backgroundGradient: some View {
        Group {
            if isSelected {
                LinearGradient(
                    gradient: Gradient(colors: [type.color, type.color.opacity(0.7)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                Color(.systemGray6)
            }
        }
    }
    
    private var shadowColor: Color {
        isSelected ? type.color.opacity(0.3) : Color.clear
    }
    
    private var iconColor: Color {
        isSelected ? .white : .gray
    }
    
    private var textColor: Color {
        isSelected ? type.color : .gray
    }
}
