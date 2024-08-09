//
//  AddStudentView.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//

import SwiftUI

struct AddStudentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var year = ""
    @State private var phone = ""
    @State private var degree = ""
    
    @State private var showingNameAlert = false
    
    let years = ["Freshman", "Sophomore", "Junior", "Senior", "Other"]
    
    var body: some View {
        Form {
            Section (header: Text("Name")) {
                TextField("Enter Name", text: $name)
            }
            Section (header: Text("Major")) {
                TextField("Enter Major", text: $degree)
            }
            Section (header: Text("Year")) {
                Picker ("Year", selection: $year) {
                    ForEach(years, id: \.self) {
                        Text($0)
                    }
                }
            }
            Section (header: Text("Phone Number")) {
                TextField("Enter Number", text: $phone)
            }
            
            Section {
                Button("Save") {
                    if name == "" {
                        showingNameAlert.toggle()
                    }
                    else {
                        let newStudent = Student(context: viewContext)
                        newStudent.id = UUID()
                        newStudent.name = name
                        newStudent.year = year
                        newStudent.degree = degree
                        newStudent.phone = phone
                        newStudent.hasMet = false
                        
                        do {
                            try viewContext.save()
                        }
                        catch {
                            print(error)
                        }
                        dismiss()
                    }
                }
            }
            .alert("Please give the student a name.", isPresented: $showingNameAlert) {}
        }
    }
}

struct AddStudentView_Previews: PreviewProvider {
    static var previews: some View {
        AddStudentView()
    }
}
