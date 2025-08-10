
import SwiftUI

struct ExpenseRowView: View {
  let expense: Expense
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(expense.name)
          .font(.headline)
        Text(expense.date, format: .dateTime.day().month().year())
          .font(.caption)
          .foregroundColor(.secondary)
      }
      
      Spacer()
      
      VStack(alignment: .trailing) {
        Text(expense.amount, format: .currency(code: "USD"))
          .font(.headline)
        Text(expense.category.rawValue)
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
    .padding(.vertical, 8)
  }
}

#Preview {
  ExpenseRowView(expense: Expense(name: "Test Expense", date: Date(), amount: 99.99, category: .gastosPersonales))
}
