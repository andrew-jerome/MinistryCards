//
//  EditMeetingView.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//

import SwiftUI

struct EditMeetingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @Binding var meeting: Meeting
    let student: Student
    
    @State private var dT = Date.now
    @State private var location = ""
    
    var body: some View {
        Form {
            Section (header: Text("Enter Date and Time")) {
                DatePicker("Enter Time", selection: $dT)
                    .labelsHidden()
                    .task {
                        dT = meeting.dT ?? Date.now
                    }
            }
            Section (header: Text("Enter location")) {
                TextField("Enter location", text: $location)
                    .task {
                        location = meeting.location ?? ""
                    }
            }
            Section {
                Button {
                    meeting.student = nil
                    meeting.dT = dT
                    meeting.location = location
                    meeting.student = student
                    
                    if student.hasMet {
                        if (student.lastMeeting?.dT ?? Date.now) < dT && dT < Date.now {
                            student.lastMeeting = meeting
                        }
                    }
                    else {
                        if dT < Date.now {
                            student.lastMeeting = meeting
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
            Section {
                Button {
                    student.hasMet = false
                    for meeting2 in student.meetingsArray {
                        if (meeting2.dT ?? Date.now) < Date.now && meeting2.dT != meeting.dT {
                            student.lastMeeting = meeting2
                            student.hasMet = true
                            break
                        }
                    }
                    viewContext.delete(meeting)
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


