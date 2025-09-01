import SwiftUI
import SharingGRDB

struct AddExpenseView: View {
  @Environment(\.dismiss) private var dismiss
  
  @State private var name = ""
  @State private var amount = ""
  @State private var rawAmount = 0.0
  @State private var category: Category = .food
  @State private var frequency: Frequency = .monthly
  @State private var date = Date()
  @State private var isFrequentlyExpense = false
  
  @AppStorage("selectedCurrency") private var selectedCurrency: Currency = .usd
  
  @Dependency(\.defaultDatabase)
  var database
  
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
        Section {
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
            // TODO: not really useful now, but can be in the future
              .onChange(of: selectedCurrency) { _, _ in
                updateFormattedAmount()
              }
            
            if rawAmount > 0 {
              Text(
                currencyFormatter.string(from: NSNumber(value: rawAmount)) ?? ""
              )
              .font(.caption)
              .foregroundColor(.blue)
            }
          }
        }
        
        Section {
          Picker("Categoría", selection: $category) {
            ForEach(Category.allCases) { category in
              Text(category.rawValue)
                .tag(category)
            }
          }
        }
        
        Section {
          DatePicker(
            "Fecha",
            selection: $date,
            displayedComponents: [.date]
          )
        }
        
        Section {
          Toggle(
            isOn: $isFrequentlyExpense,
            label: {
              Text("Pago recurrente?")
            }
          )
          
          if isFrequentlyExpense {
            Picker("Frecuencia", selection: $frequency) {
              ForEach(Frequency.allCases) { frequency in
                Text(frequency.rawValue)
                  .tag(frequency)
              }
            }
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
    guard isValidAmount else { return }
    
    let draft = Expense.Draft(
      name: name,
      date: date,
      amount: rawAmount,
      category: category,
      frequency: frequency
    )
    
    try! database.write { db in
      try! Expense
        .insert{ draft }
        .execute(db)
    }
    
    dismiss()
  }
  
  private var isValidAmount: Bool {
    rawAmount > 0
  }
  
  private func formatAmountInput(_ input: String) {
    let cleanedInput = sanitizeNumericInput(input)
    let formattedInput = limitToTwoDecimals(cleanedInput)
    updateRawAmount(from: formattedInput)
    updateDisplayAmount(formattedInput)
  }
  
  private func sanitizeNumericInput(_ input: String) -> String {
    let filtered = input.filter { "0123456789.,".contains($0) }
    return filtered.replacingOccurrences(of: ",", with: ".")
  }
  
  private func limitToTwoDecimals(_ input: String) -> String {
    let components = input.components(separatedBy: ".")
    guard components.count > 1 else { return input }
    
    let integerPart = components[0]
    let decimalPart = String(components[1].prefix(2))
    return "\(integerPart).\(decimalPart)"
  }
  
  private func updateRawAmount(from input: String) {
    rawAmount = Double(input) ?? 0
  }
  
  private func updateDisplayAmount(_ newValue: String) {
    guard newValue != amount else { return }
    amount = newValue
  }
  
  private func updateFormattedAmount() {
    if rawAmount > 0 {
      amount = inputFormatter.string(from: NSNumber(value: rawAmount)) ?? ""
    }
  }
}

#Preview {
  AddExpenseView()
}
