import SwiftUI

// Define the following colors in Colors.xcassets:
// - AccentColor: #5E72EB (hex)
// - BackgroundColor: Light mode #F8F9FA, dark mode #121212
// - CardBackground: Light mode #FFFFFF, dark mode #1E1E1E
// - InputBackground: Light mode #F0F0F5, dark mode #2C2C2E
// - TabBarBackground: Light mode #FFFFFF, dark mode #1C1C1E
// - MessageBubbleBackground: Light mode #F0F0F5, dark mode #2C2C2E

struct AppTheme {
    // Define custom themes and color schemes here
    static let gradients = AppGradients()
    static let shadows = AppShadows()
    static let spacing = AppSpacing()
    static let cornerRadius = AppCornerRadius()
}