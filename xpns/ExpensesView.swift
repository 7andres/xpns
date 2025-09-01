import SwiftUI
import SharingGRDB

enum SortOrder {
  case none
  case ascending
  case descending
}

struct ExpensesView: View {
  @State private var isAddingExpense = false
  @State private var searchText = ""
  @State private var selectedCategory: Category? = nil
  @State private var sortOrder: SortOrder = .none
  
  @FetchAll
  private var expenses: [Expense]
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(expenses) { expense in
          ExpenseRowView(expense: expense)
        }
      }
      .navigationTitle("Gastos")
      .searchable(text: $searchText, prompt: "Buscar gastos")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: { isAddingExpense = true }) {
            Image(systemName: "plus")
          }
        }
        ToolbarItem(placement: .navigationBarLeading) {
          Menu {
            Button(action: { selectedCategory = nil }) {
              Text("Todas las categorias")
            }
            ForEach(Category.allCases) { category in
              Button(action: { selectedCategory = category }) {
                Text(category.rawValue)
              }
            }
            
            Divider()
            
            Button(action: { sortOrder = .ascending }) {
              Text("Monto (ascendente)")
            }
            
            Button(action: { sortOrder = .descending }) {
              Text("Monto (descendente)")
            }
            
            Button(action: { sortOrder = .none }) {
              Text("Sin ordenar")
            }
            
          } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
          }
        }
      }
      .sheet(isPresented: $isAddingExpense) {
        AddExpenseView()
      }
    }
  }
}

#Preview {
  ExpensesView()
}
