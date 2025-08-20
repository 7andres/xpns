# xpns

xpns is a lightweight SwiftUI app for tracking and managing personal expenses on iOS.

## Project Overview

- **Name**: xpns — SwiftUI expense tracking app (iOS 17+)
- **Architecture**: GRDB-based data persistence with Point-Free's Dependencies pattern; declarative SwiftUI views with no unnecessary ViewModels
- **Persistence**: SQLite database using GRDB framework with automatic migrations; database access via dependency injection
- **Features**:
  - Expense list with search, category filter, and amount sorting
  - Add expenses with basic amount validation and currency formatting
  - Currency selection in Settings via `@AppStorage("selectedCurrency")` (options: `USD`, `COP`)
  - Persistent SQLite storage with automatic database migrations
- **Models**: `Expense` (with `@Table` annotation), `Category` (QueryBindable), `Currency`
- **Key Views**: `ContentView` (tabs), `ExpensesView`, `AddExpenseView`, `ExpenseRowView`, `SettingsView`
- **Dependencies**: SharingGRDB (v0.5.0) for SwiftUI integration with GRDB

## Architecture

### Database Layer

The app uses GRDB with SharingGRDB for data persistence with the following architecture:

- **GRDB Framework**: Robust SQLite interface with advanced features like migrations and change observation
- **SharingGRDB Package**: Point-Free's SwiftUI integration layer that adds declarative macros on top of GRDB
- **Automatic Migrations**: Schema changes are handled through GRDB's `DatabaseMigrator`
- **@Table Macro**: The `Expense` model uses SharingGRDB's `@Table` macro for automatic model-to-database mapping
- **Dependency Injection**: Database access is injected via Point-Free's Dependencies package (`@Dependency(\.defaultDatabase)`)

### Key Implementation Details

```swift
// Expense model with SharingGRDB's @Table macro
@Table
struct Expense: Identifiable, Hashable {
  let id: Int
  var name: String
  var date: Date
  var amount: Double
  var category: Category
}

// Database access via Dependencies package
@Dependency(\.defaultDatabase)
var database

// Reactive data fetching with SharingGRDB's @FetchAll
@FetchAll
private var expenses: [Expense]
```

## Requirements

- Xcode with iOS 17 SDK or later
- Swift 5.9+

## Getting Started

1. Open `xpns.xcodeproj` in Xcode.
2. Select an iOS 17+ simulator or a device.
3. Build and run.

The app will automatically create and migrate the SQLite database on first launch.