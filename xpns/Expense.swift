
import Foundation
import Observation
import SharingGRDB

enum Frequency: String, CaseIterable, Identifiable, QueryBindable {
  case daily = "Diario"
  case weekly = "Semanal"
  case monthly = "Mensual"
  case yearly = "Anual"
  case nonRepeatable = "No repetible"

  var id: String { rawValue }
}

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
  var frequency: Frequency? = nil
}
