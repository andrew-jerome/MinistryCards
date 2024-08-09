//
//  EditStudentView.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//

import SwiftUI

struct EditStudentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    let student: Student
    
    @State private var name = ""
    @State private var year = ""
    @State private var phone = ""
    @State private var degree = ""
    
    let years = ["Freshman", "Sophomore", "Junior", "Senior", "Other"]
    
    var body: some View {
        Form {
            Section (header: Text(name)) {
                TextField("Name", text: $name)
                    .task {
                        name = student.name ?? ""
                    }
            }
            Section (header: Text("Major")) {
                TextField(degree, text: $degree)
                    .task {
                        degree = student.degree ?? ""
                    }
            }
            Section (header: Text("Year")) {
                Picker ("Year", selection: $year) {
                    ForEach(years, id: \.self) {
                        Text($0)
                    }
                }
                .task {
                    year = student.year ?? ""
                }
            }
            Section (header: Text("Phone Number")) {
                TextField(phone, text: $phone)
                    .task {
                        phone = student.phone ?? ""
                    }
            }
            
            Section {
                Button("Save") {
                    student.name = name
                    student.year = year
                    student.degree = degree
                    student.phone = phone
                    
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
    }
}
