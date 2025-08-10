
import SwiftUI

struct AddExpenseView: View {
  @Environment(ExpenseStore.self) private var store
  @Environment(\.dismiss) private var dismiss
  
  @State private var name = ""
  @State private var amount = ""
  @State private var rawAmount = 0.0
  @State private var category: Category = .comida
  
  @AppStorage("selectedCurrency") private var selectedCurrency: Currency = .usd
  
  private var currencyFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = selectedCurrency.rawValue
    formatter.maximumFractionDigits = 2
    return formatter
  }
  
  private var inputFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    return formatter
  }
  
  var body: some View {
    NavigationStack {
      Form {
        TextField("Nombre", text: $name)
        
        VStack(alignment: .leading, spacing: 4) {
          Text("Monto")
            .font(.caption)
            .foregroundColor(.secondary)
          
          TextField("0.00", text: $amount)
            .keyboardType(.decimalPad)
            .onChange(of: amount) { _, newValue in
              formatAmountInput(newValue)
            }
            .onChange(of: selectedCurrency) { _, _ in
              updateFormattedAmount()
            }
          
          if rawAmount > 0 {
            Text(currencyFormatter.string(from: NSNumber(value: rawAmount)) ?? "")
              .font(.caption)
              .foregroundColor(.blue)
          }
        }
        
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
    let finalAmount = rawAmount > 0 ? rawAmount : (Double(amount) ?? 0)
    guard finalAmount > 0 else { return }
    let newExpense = Expense(name: name, date: Date(), amount: finalAmount, category: category)
    store.expenses.append(newExpense)
    dismiss()
  }
  
  private func formatAmountInput(_ input: String) {
    // Remover caracteres no numéricos excepto punto y coma
    let filtered = input.filter { "0123456789.,".contains($0) }
    
    // Reemplazar coma con punto para consistencia
    let normalized = filtered.replacingOccurrences(of: ",", with: ".")
    
    // Limitar a máximo 2 decimales
    let components = normalized.components(separatedBy: ".")
    var result = components[0]
    
    if components.count > 1 {
      let decimals = String(components[1].prefix(2))
      result = "\(result).\(decimals)"
    }
    
    // Actualizar el valor raw
    rawAmount = Double(result) ?? 0
    
    // Actualizar el texto solo si es diferente para evitar bucles
    if result != amount {
      amount = result
    }
  }
  
  private func updateFormattedAmount() {
    if rawAmount > 0 {
      amount = inputFormatter.string(from: NSNumber(value: rawAmount)) ?? ""
    }
  }
}

#Preview {
  AddExpenseView()
    .environment(ExpenseStore())
}
