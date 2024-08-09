//
//  EditPrayerView.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//

import SwiftUI

struct EditPrayerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @Binding var prayer: Prayer
    let student: Student
    
    @State private var content = ""
    @State private var hasDate = false
    @State private var dT = Date.now

    var body: some View {
            Form {
                Section (header: Text("Prayer Reqeust")){
                    TextEditor(text: $content)
                        .task {
                            content = prayer.content ?? ""
                        }
                }
                Section (header: Text("Add Date")) {
                    Toggle("Add Date", isOn: $hasDate)
                        .task {
                            hasDate = prayer.hasDate
                            if hasDate {
                                dT = prayer.dT ?? Date.now
                            }
                        }
                    if hasDate {
                        DatePicker("Enter Time", selection: $dT, displayedComponents: [.date])
                            .labelsHidden()
                    }
                }
                Section {
                    Button {
                        prayer.student = nil
                        prayer.content = content
                        prayer.hasDate = hasDate
                        prayer.student = student
                        if hasDate {
                            prayer.dT = dT
                        }
   
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
                Section {
                    Button {
                        viewContext.delete(prayer)
                        do {
                            try viewContext.save()
                        }
                        catch {
                            print(error)
                        }
                        dismiss()
                    } label: {
                        Text("Delete")
                            .foregroundColor(.red)
                    }
                }
            }
    }
}
