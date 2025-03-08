import Foundation
import SwiftUI

struct OnboardingPage: Identifiable {
    var id = UUID()
    let title: String
    let description: String
    let imageName: String
    let backgroundColor: Color

    init(title: String, description: String, imageName: String, backgroundColor: Color) {
        self.title = title
        self.description = description
        self.imageName = imageName
        self.backgroundColor = backgroundColor
    }
}