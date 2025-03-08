import SwiftUI

struct ProgressBar: View {
    @Binding var value: Float

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Arkaplan
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .cornerRadius(5)

                // Değer çubuğu
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: CGFloat(value) * geometry.size.width)
                    .cornerRadius(5)
            }
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(value: .constant(0.7))
            .frame(height: 6)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}