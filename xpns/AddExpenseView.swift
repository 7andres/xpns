
import SwiftUI

struct AddExpenseView: View {
  @Environment(ExpenseStore.self) private var store
  @Environment(\.dismiss) private var dismiss
  
  @State private var name = ""
  @State private var amount = ""
  @State private var category: Category = .comida
  
  @AppStorage("selectedCurrency") private var selectedCurrency: Currency = .usd
  
  var body: some View {
    NavigationStack {
      Form {
        TextField("Nombre", text: $name)
        TextField("Monto", text: $amount)
          .keyboardType(.decimalPad)
        Picker("Categoría", selection: $category) {
          ForEach(Category.allCases) { category in
            Text(category.rawValue).tag(category)
          }
        }
      }
      .navigationTitle("Nuevo Gasto")
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancelar") { dismiss() }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Guardar") { saveExpense() }
        }
      }
    }
  }
  
  private func saveExpense() {
    guard let amount = Double(amount) else { return }
    let newExpense = Expense(name: name, date: Date(), amount: amount, category: category)
    store.expenses.append(newExpense)
    dismiss()
  }
}

#Preview {
  AddExpenseView()
    .environment(ExpenseStore())
}
