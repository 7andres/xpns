
import Foundation
import Observation

enum Category: String, CaseIterable, Identifiable, Codable {
  case comida = "Comida"
  case pagosDeFacturas = "Pagos de Facturas"
  case gastosPersonales = "Gastos Personales"
  
  var id: String { self.rawValue }
}

struct Expense: Identifiable, Hashable, Codable {
  let id: UUID
  var name: String
  var date: Date
  var amount: Double
  var category: Category
  
  init(id: UUID = UUID(), name: String, date: Date, amount: Double, category: Category) {
    self.id = id
    self.name = name
    self.date = date
    self.amount = amount
    self.category = category
  }
}

@Observable
class ExpenseStore {
  var expenses: [Expense] = []
  
  private static func fileURL() throws -> URL {
    try FileManager.default.url(for: .documentDirectory,
                                in: .userDomainMask,
                                appropriateFor: nil,
                                create: false)
    .appendingPathComponent("expenses.data")
  }
  
  func load() async throws {
    let task = Task<[Expense], Error> {
      let fileURL = try Self.fileURL()
      guard let data = try? Data(contentsOf: fileURL) else {
        return []
      }
      let expenses = try JSONDecoder().decode([Expense].self, from: data)
      return expenses
    }
    let expenses = try await task.value
    self.expenses = expenses
  }
  
  func save(expenses: [Expense]) async throws {
    let task = Task {
      let data = try JSONEncoder().encode(expenses)
      let outfile = try Self.fileURL()
      try data.write(to: outfile)
    }
    _ = try await task.value
  }
}
