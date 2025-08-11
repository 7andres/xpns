# xpns

xpns is a lightweight SwiftUI app for tracking and managing personal expenses on iOS.

## Project Overview

- **Name**: xpns — SwiftUI expense tracking app (iOS 17+)
- **Architecture**: Centralized state in `@Observable` `ExpenseStore` injected via `@Environment`; declarative SwiftUI views with no unnecessary ViewModels
- **Persistence**: JSON file in the app Documents directory (`expenses.data`) via `ExpenseStore.load()` and `ExpenseStore.save(...)`
- **Features**:
  - Expense list with search, category filter, and amount sorting
  - Add expenses with basic amount validation and currency formatting
  - Currency selection in Settings via `@AppStorage("selectedCurrency")` (options: `USD`, `COP`)
- **Models**: `Expense`, `Category`, `Currency`
- **Key Views**: `ContentView` (tabs), `ExpensesView`, `AddExpenseView`, `ExpenseRowView`, `SettingsView`

## Requirements

- Xcode with iOS 17 SDK or later
- Swift 5.9+

## Getting Started

1. Open `xpns.xcodeproj` in Xcode.
2. Select an iOS 17+ simulator or a device.
3. Build and run.
