//
//  aliveApp.swift
//  alive
//
//  Created by 船木勇斗 on 2023/01/12.
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
