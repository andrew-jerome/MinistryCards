//
//  MainView.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//

import SwiftUI

struct MainView: View {
    @StateObject private var persistenceController = PersistenceController()
    
    var body: some View {
        TabView {
            Group {
                DayView()
                    .tabItem {
                        Label("Today", systemImage: "calendar")
                    }
                ListView()
                    .tabItem {
                        Label("Students", systemImage: "person.3")
                    }
                OtherView()
                    .tabItem {
                        Label("Other", systemImage: "gearshape")
                    }
            }
            .accentColor(Color("PrimaryColor"))
            //.toolbarBackground(.visible, for: .tabBar, .navigationBar)
            //.toolbarBackground(Color("PrimaryColor"), for: .tabBar, .navigationBar)
        }
        
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
