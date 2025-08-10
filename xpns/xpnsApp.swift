//
//  xpnsApp.swift
//  xpns
//
//  Created by Andrés Carrillo on 9/08/25.
//

import SwiftUI

@main
struct xpnsApp: App {
  @State private var store = ExpenseStore()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(store)
        .task {
          do {
            try await store.load()
          } catch {
            fatalError(error.localizedDescription)
          }
        }
    }
  }
}
