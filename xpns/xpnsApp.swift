//
//  xpnsApp.swift
//  xpns
//
//  Created by Andrés Carrillo on 9/08/25.
//

import SwiftUI
import SharingGRDB

@main
struct xpnsApp: App {
  
  init() {
    prepareDependencies {
      $0.defaultDatabase = try! appDatabase()
    }
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
  
  private func appDatabase() throws -> any DatabaseWriter {
    @Dependency(\.context) var context
    
    var configuration = Configuration()
    configuration.foreignKeysEnabled = true
    
    #if DEBUG
    configuration.prepareDatabase { db in
      db.trace(options: .profile) {
        if context == .preview {
          print("\($0.expandedDescription)")
        } else {
          logger.debug("\($0.expandedDescription)")
        }
      }
    }
    #endif
    
    let database: any DatabaseWriter
    if context == .live {
      let path = URL.documentsDirectory.appending(component: "db.sqlite").path()
      logger.info("open \(path)")
      database = try DatabasePool(path: path, configuration: configuration)
    } else if context == .test {
      let path = URL.temporaryDirectory.appending(component: "\(UUID().uuidString)-db.sqlite").path()
      database = try DatabasePool(path: path, configuration: configuration)
    } else {
      database = try DatabaseQueue(configuration: configuration)
    }
    
    var migrator = DatabaseMigrator()
    #if DEBUG
    migrator.eraseDatabaseOnSchemaChange = true
    #endif
    migrator.registerMigration("Create expenses table") { db in
      try db.create(table: "expenses") { td in
        td.autoIncrementedPrimaryKey("id")

        td.column("name", .text)
          .notNull()
          .defaults(to: "")

        td.column("date", .datetime)

        td.column("amount", .double)

        td.column("category", .text)
          .notNull()
          .defaults(to: Category.defaultCategory.rawValue)

        td.column("frequency", .text)
      }
    }
    
    try migrator.migrate(database)
    
    return database
  }
}

import OSLog

fileprivate let logger = Logger(subsystem: "xpnsApp", category: "Database")
