//
//  MinistryCardsApp.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//

import SwiftUI

@main
struct MinistryCardsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
