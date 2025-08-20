# AI Assistant Guidelines

This document provides guidance for AI assistants (e.g., Gemini, Cursor, Claude.ai/code) when working with code in this repository.

## Project Overview

xpns is an app to track and control personal expenses, built with Swift and SwiftUI. Main features include:

- View and search expenses
- Filter by category
- Sort by amount
- Add new expenses
- Choose display currency (USD, COP)
- Persistent storage with SQLite database using GRDB

## Code formatting

The project uses SwiftFormat with 2-space indentation.

## General Principles

*   **Follow Existing Conventions:** Before making any changes, review the existing code to understand its style, structure, and patterns. Ensure that your contributions are consistent with the established conventions.
*   **Test Your Changes:** If you make any changes to the code, make sure to test them thoroughly to ensure that they don't introduce any new bugs or regressions.
*   **Keep it Simple:** Strive for simplicity and clarity in your code. Avoid unnecessary complexity and clever tricks that might make the code harder to understand and maintain.
*   **Document Your Code:** Add comments to your code to explain what it does, how it works, and why it's necessary. This will help other developers (and AI assistants) to understand your code in the future.

## Modern Swift Patterns

Follow modern Swift/SwiftUI patterns:

*   Use @Observable (iOS 17+/macOS 14+) instead of ObservableObject
*   Avoid unnecessary ViewModels - keep state in views when appropriate
*   Use @State and @Environment for dependency injection
*   Embrace SwiftUI's declarative nature, don't fight the framework
*   Use GRDB for SQLite operations with SharingGRDB for SwiftUI integration and declarative data access
*   See the file modern-swift.md in the root project for details

## Database Architecture

The project uses GRDB with SharingGRDB for data persistence:

*   **GRDB Framework:** Provides robust SQLite interface with advanced features like migrations and change observation
*   **SharingGRDB Package:** Point-Free's SwiftUI integration layer that adds declarative macros and dependency injection on top of GRDB
*   **Migration System:** Database schema is managed through GRDB's DatabaseMigrator
*   **@Table Macro:** SharingGRDB's macro for automatic model-to-database mapping (not part of GRDB)
*   **@FetchAll Macro:** SharingGRDB's property wrapper for reactive data fetching in SwiftUI
*   **Dependency Injection:** Database access via Point-Free's Dependencies package (`@Dependency(\.defaultDatabase)`)
*   **Testing Support:** Different database configurations for live, test, and preview contexts

### Key Components:
- `Expense` model with SharingGRDB's `@Table` annotation for automatic database mapping
- Database initialization and migration using GRDB's APIs in `xpnsApp.swift`
- Category enum implements SharingGRDB's `QueryBindable` for database operations
- Views use SharingGRDB's `@FetchAll` and GRDB's direct database writes for data operations
