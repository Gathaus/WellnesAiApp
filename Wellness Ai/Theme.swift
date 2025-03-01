import SwiftUI

// Colors.xcassets içinde şu renkleri tanımlayın:
// - AccentColor: #5E72EB (hex)
// - BackgroundColor: Açık mod için #F8F9FA, karanlık mod için #121212
// - CardBackground: Açık mod için #FFFFFF, karanlık mod için #1E1E1E
// - InputBackground: Açık mod için #F0F0F5, karanlık mod için #2C2C2E
// - TabBarBackground: Açık mod için #FFFFFF, karanlık mod için #1C1C1E
// - MessageBubbleBackground: Açık mod için #F0F0F5, karanlık mod için #2C2C2E

// Theme.swift
struct AppTheme {
    // Özel temalar ve renk şemalarını burada tanımlayabilirsiniz
    
    static let gradients = AppGradients()
    static let shadows = AppShadows()
    static let spacing = AppSpacing()
    static let cornerRadius = AppCornerRadius()
}

struct AppGradients {
    let primary = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "5E72EB"), Color(hex: "FF9190")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    let secondary = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "43B692"), Color(hex: "099773")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    let tertiary = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "FF9190"), Color(hex: "FDC094")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct AppShadows {
    let small = Shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    let medium = Shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    let large = Shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

struct AppSpacing {
    let small: CGFloat = 8
    let medium: CGFloat = 16
    let large: CGFloat = 24
    let extraLarge: CGFloat = 32
}

struct AppCornerRadius {
    let small: CGFloat = 8
    let medium: CGFloat = 12
    let large: CGFloat = 20
    let extraLarge: CGFloat = 30
}
