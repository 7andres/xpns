
import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      ExpensesView()
        .tabItem {
          Label("Gastos", systemImage: "list.bullet")
        }
      
      SettingsView()
        .tabItem {
          Label("Configuración", systemImage: "gear")
        }
    }
  }
}

#Preview {
  ContentView()
    .environment(ExpenseStore())
}
