import SwiftUI

struct MeditationView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @State private var selectedCategory: MeditationType = .focus

    var body: some View {
        VStack(spacing: 0) {
            // Başlık kısmı
            headerView

            // Kategori seçici
            CategorySelectorView(selectedCategory: $selectedCategory)

            // Meditasyon listesi
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    // Önerilen meditasyonlar
                    featuredMeditationsSection

                    // Tüm meditasyonlar
                    allMeditationsSection

                    Spacer()
                        .frame(height: 100)
                }
            }
            .background(Color(.systemGray6))
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }

    // MARK: - UI Bileşenleri

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Meditasyon")
                .font(.system(size: 28, weight: .bold, design: .rounded))

            Text("İç huzuru keşfet")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
    }

    private var featuredMeditationsSection: some View {
        VStack(alignment: .leading) {
            Text("Önerilen Meditasyonlar")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(.horizontal)
                .padding(.top, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(filteredMeditations.prefix(3)) { meditation in
                        MeditationCard(meditation: meditation)
                            .frame(width: 280, height: 180)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private var allMeditationsSection: some View {
        VStack(alignment: .leading) {
            Text("Tüm Meditasyonlar")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(.horizontal)
                .padding(.top, 20)

            ForEach(filteredMeditations) { meditation in
                MeditationListItem(meditation: meditation)
                    .padding(.horizontal)
            }
        }
    }

    // MARK: - Yardımcı Metotlar

    private var filteredMeditations: [Meditation] {
        return sampleMeditations.filter { $0.type == selectedCategory }
    }
}

struct MeditationView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationView()
            .environmentObject(WellnessViewModel())
    }
}