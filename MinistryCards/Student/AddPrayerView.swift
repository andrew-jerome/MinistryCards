//
//  AddPrayerView.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//

import SwiftUI

struct AddPrayerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    let student: Student
    
    @State private var content = "Enter prayer"
    @State private var hasDate = false
    @State private var dT = Date.now

    var body: some View {
            Form {
                Section (header: Text("New Prayer Reqeust")){
                    TextEditor(text: $content)
                }
                Section (header: Text("Add Date")) {
                    Toggle("Add Date", isOn: $hasDate)
                    if hasDate {
                        DatePicker("Enter Time", selection: $dT, displayedComponents: [.date])
                            .labelsHidden()
                    }
                }
                Section {
                    Button {
                        let newPrayer = Prayer(context: viewContext)
                        newPrayer.content = content
                        newPrayer.student = student
                        newPrayer.hasDate = hasDate
                        newPrayer.dT = dT
                        do {
                            try viewContext.save()
                        }
                        catch {
                            print(error)
                        }
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                }
            }
          
    }
}
