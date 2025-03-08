import SwiftUI

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