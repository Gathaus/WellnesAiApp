import SwiftUI

// Colors.xcassets içinde şu renkleri tanımlayın:
// - AccentColor: #5E72EB (hex)
// - BackgroundColor: Açık mod için #F8F9FA, karanlık mod için #121212
// - CardBackground: Açık mod için #FFFFFF, karanlık mod için #1E1E1E
// - InputBackground: Açık mod için #F0F0F5, karanlık mod için #2C2C2E
// - TabBarBackground: Açık mod için #FFFFFF, karanlık mod için #1C1C1E
// - MessageBubbleBackground: Açık mod için #F0F0F5, karanlık mod için #2C2C2E

struct AppTheme {
    // Özel temalar ve renk şemalarını burada tanımlayabilirsiniz
    static let gradients = AppGradients()
    static let shadows = AppShadows()
    static let spacing = AppSpacing()
    static let cornerRadius = AppCornerRadius()
}