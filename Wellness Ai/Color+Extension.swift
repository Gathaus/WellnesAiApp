import SwiftUI

extension Color {
    // Additional modern colors
    static var primaryText: Color {
        return Color(UIColor.label)
    }
    
    static var secondaryText: Color {
        return Color(UIColor.secondaryLabel)
    }
    
    // Shades of blue
    static var lightBlue: Color {
        return Color(hex: "7A9BFF")
    }
    
    static var primaryBlue: Color {
        return Color(hex: "5E72EB")
    }
    
    static var darkBlue: Color {
        return Color(hex: "4859CB")
    }
    
    // Shades of purple
    static var lightPurple: Color {
        return Color(hex: "B19FFF")
    }
    
    static var primaryPurple: Color {
        return Color(hex: "8347E6")
    }
    
    static var darkPurple: Color {
        return Color(hex: "6C30C5")
    }
    
    // Theme colors
    static var positiveGreen: Color {
        return Color(hex: "4CAF50")
    }
    
    static var warningOrange: Color {
        return Color(hex: "FF9800")
    }
    
    static var negativeRed: Color {
        return Color(hex: "F44336")
    }
    
    static var neutralGray: Color {
        return Color(hex: "9E9E9E")
    }
}

// Modern gradient extension
extension LinearGradient {
    static var primaryGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.primaryBlue, Color.primaryPurple]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var secondaryGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.lightBlue, Color.lightPurple]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var blueGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.lightBlue, Color.darkBlue]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    static var purpleGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.lightPurple, Color.darkPurple]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
