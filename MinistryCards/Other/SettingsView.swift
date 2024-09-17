//
//  OtherView.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var numPrayers = 3
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink {
                        TagsView()
                    } label: {
                        Text("Manage Small Groups")
                    }
                }
                
                Section {
                    Picker("Prayers Per Day", selection: $numPrayers) {
                        ForEach(1..<10) {
                            Text("\($0)")
                        }
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
