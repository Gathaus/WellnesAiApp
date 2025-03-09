import SwiftUI

struct SettingRow: View {
    let icon: String
    let title: String
    let iconColor: Color

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(iconColor)
                .cornerRadius(10)

            Text(title)
                .font(.system(size: 16, design: .rounded))

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
    }
}

struct SettingRow_Previews: PreviewProvider {
    static var previews: some View {
        SettingRow(
            icon: "bell.fill",
            title: "Daily Reminders",
            iconColor: .orange
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}