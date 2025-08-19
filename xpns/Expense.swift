
import Foundation
import Observation
import SharingGRDB

enum Category: String, CaseIterable, Identifiable, QueryBindable {
  case food = "Comida"
  case bills = "Pagos de Facturas"
  case personal = "Gastos Personales"
  case defaultCategory = "Sin categoría"
  
  
  var id: String { rawValue }
}

@Table
struct Expense: Identifiable, Hashable {
  let id: Int
  var name: String = ""
  var date: Date = .now
  var amount: Double
  var category: Category
}
