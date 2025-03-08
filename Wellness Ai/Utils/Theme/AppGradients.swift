import SwiftUI

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