//
//  AddMeetingView.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//

import SwiftUI
import SwiftUI

struct AddMeetingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    let student: Student
    
    @State private var dT = Date.now
    @State private var location = ""
    
    var body: some View {
        Form {
            Section (header: Text("Enter Date and Time")) {
                DatePicker("Enter Time", selection: $dT)
                    .labelsHidden()
            }
            Section (header: Text("Enter location")) {
                TextField("Enter location", text: $location)
            }
            Section {
                Button {
                    let newMeeting = Meeting(context: viewContext)
                    newMeeting.student = student
                    newMeeting.dT = dT
                    newMeeting.location = location
                    
                    if student.hasMet {
                        if (student.lastMeeting?.dT ?? Date.now) < dT && dT < Date.now {
                            student.lastMeeting = newMeeting
                        }
                    }
                    else {
                        if dT < Date.now {
                            student.lastMeeting = newMeeting
                            student.hasMet = true
                        }
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
        }
    }
}

