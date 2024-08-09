//
//  AddNoteView.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//

import SwiftUI

struct AddNoteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    let student: Student
    
    @State private var content = "Enter note"
    @State private var hasDate = false
    @State private var dT = Date.now

    var body: some View {
       // NavigationView {
            Form {
                Section (header: Text("New Note")){
                    //TextField("Enter Note", text: $content)
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
                        let newNote = Note(context: viewContext)
                        newNote.content = content
                        newNote.student = student
                        newNote.hasDate = hasDate
                        //if hasDate {
                            newNote.dT = dT
//                        }
//                        else {
//                            newNote.dT = Date.now.addingTimeInterval(-1000000)
//                        }
                     
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
            //.navigationTitle("New Note")
            //.toolbar {
               /* ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }*/
              /*  ToolbarItem(placement: .principal) {
                    Text("New Note")
                        .bold()                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        let newNote = Note(context: viewContext)
                        newNote.content = content
                        newNote.student = student
                        newNote.hasDate = hasDate
                 
                        try? viewContext.save()
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                }
            }*/
       // }
    }
}
/*
 struct AddNoteView_Previews: PreviewProvider {
 static var previews: some View {
 AddNoteView()
 }
 }
 */

