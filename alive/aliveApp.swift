//
//  aliveApp.swift
//  alive
//
//  Created by čšć¨ĺć on 2023/01/12.
//

import SwiftUI

@main
struct aliveApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
