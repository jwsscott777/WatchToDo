//
//  WatchToDoApp.swift
//  WatchToDo WatchKit Extension
//
//  Created by JWSScott777 on 12/18/20.
//

import SwiftUI

@main
struct WatchToDoApp: App {
    let persistenceController = PersistenceController()
    var body: some Scene {
        WindowGroup {
            NavigationView {
               TasksView()
                    .environment(\.managedObjectContext,
                                 persistenceController.container.viewContext)
            }
        }
    }
}
