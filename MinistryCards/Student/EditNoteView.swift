//
//  EditNoteView.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//

import SwiftUI

struct EditNoteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @Binding var note: Note
    let student: Student

    @State private var content = ""
    @State private var hasDate = false
    @State private var dT = Date.now

    var body: some View {
            Form {
                Section (header: Text("Prayer Reqeust")){
                    TextEditor(text: $content)
                        .task {
                            content = note.content ?? ""
                        }
                }
                Section (header: Text("Add Date")) {
                    Toggle("Add Date", isOn: $hasDate)
                        .task {
                            hasDate = note.hasDate
                            if hasDate {
                                dT = note.dT ?? Date.now
                            }
                        }
                    if hasDate {
                        DatePicker("Enter Time", selection: $dT, displayedComponents: [.date])
                            .labelsHidden()
                    }
                }
                Section {
                    Button {
                        note.student = nil
                        note.content = content
                        note.hasDate = hasDate
                        note.student = student
                        if hasDate {
                            note.dT = dT
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
                        viewContext.delete(note)
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
