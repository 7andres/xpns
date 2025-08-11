# AI Assistant Guidelines

This document provides guidance for AI assistants (e.g., Gemini, Cursor, Claude.ai/code) when working with code in this repository.

## Project Overview

xpns is an app to track and control personal expenses, built with Swift and SwiftUI. Main features include:

- View and search expenses
- Filter by category
- Sort by amount
- Add new expenses
- Choose display currency (USD, COP)

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
*   See the file modern-swift.md in the root project for details
