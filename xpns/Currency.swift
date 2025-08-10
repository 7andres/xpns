
import Foundation

enum Currency: String, CaseIterable, Identifiable {
  case usd = "USD"
  case cop = "COP"
  
  var id: String { self.rawValue }
}
