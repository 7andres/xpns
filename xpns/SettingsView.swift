import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedCurrency") private var selectedCurrency: Currency = .usd

    var body: some View {
        NavigationStack {
            Form {
                Picker("Moneda", selection: $selectedCurrency) {
                    ForEach(Currency.allCases) {
                        currency in
                        Text(currency.rawValue).tag(currency)
                    }
                }
            }
            .navigationTitle("Configuración")
        }
    }
}

#Preview {
    SettingsView()
}
