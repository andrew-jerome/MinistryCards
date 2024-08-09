//
//  StudentDetail.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//

import Foundation
import CoreData
import SwiftUI

struct StudentDetail: View {
    @Environment(\.managedObjectContext) private var viewContext
    let student: Student
    
    @FetchRequest(sortDescriptors: []) var allTags: FetchedResults<Tag>
 
    var dateFormatter = DateFormatter()
    var dateFormat2 = DateFormatter()
    var dateFormat3 = DateFormatter()
    var dateFormat4 = DateFormatter()
    let time = Date.now
    
    @State private var showingAddNoteView = false
    @State private var showingAddPrayerView = false
    @State private var showingEditStudentView = false
    @State private var showingAddMeetingView = false
    @State private var showingEditPrayerView = false
    @State private var showingEditNoteView = false
    @State private var showingEditMeetingView = false
    @State private var showingCreateTag = false
    @State private var showDeleteTag = false
    @State private var userChange = true
    @State private var notePrayerEdited = false
    
    @State private var tagName = ""
    
    @State private var prayerToEdit = Prayer()
    @State private var noteToEdit = Note()
    @State private var meetingToEdit = Meeting()
    @State private var newTag = Tag()
    
    init (student: Student) {
        self.student = student
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormat2.dateFormat = "h:mm a 'on' MMMM dd"
        dateFormat3.dateFormat = "MMMM dd, yyyy"
        dateFormat4.dateFormat = "MMMM dd"
    }
    
    var body: some View {
        VStack {
            Text("Year: " + student.wrappedYear)
            Text("Major: " + student.wrappedDegree)
            Text("Phone: " + student.wrappedPhone)
            
            Divider()
                .overlay(Color("PrimaryColor"))
            
            ScrollView(.vertical) {
                HStack {
                    VStack {
                        Text("Future Meetings")
                            .font(.headline)
                        
                        ForEach(student.meetingsArray) { meeting in
                            let dT = meeting.dT!
                            if dT > time {
                                if meeting.location != "" {
                                    VStack {
                                        Text(dT, formatter: dateFormat2)
                                        + Text(" at " + (meeting.location ?? ""))
                                    }
                                    .multilineTextAlignment(.center)
                                    .onTapGesture {
                                        meetingToEdit = meeting
                                        showingEditMeetingView.toggle()
                                    }
                                }
                                else {
                                    Text(dT, formatter: dateFormat2)
                                        .multilineTextAlignment(.center)
                                        .onTapGesture {
                                            meetingToEdit = meeting
                                            showingEditMeetingView.toggle()
                                        }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Text("Past Meetings")
                            .font(.headline)
                        
                        ForEach(student.meetingsArray) { meeting in
                            let dT = meeting.dT!
                            if dT < time {
                                Text(dT, formatter: dateFormat3)
                                    .multilineTextAlignment(.center)
                                    .onTapGesture {
                                        meetingToEdit = meeting
                                        showingEditMeetingView.toggle()
                                    }
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            showingAddMeetingView.toggle()
                        } label: {
                            Text("Add Meeting")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                        .overlay(Color("PrimaryColor"))
                    
                    VStack {
                        Text("Small Groups")
                            .font(.headline)
                        
                        ForEach(student.tagsArray) { tag in
                            HStack {
                                Text(tag.name ?? "")
                                    .onTapGesture {
                                        showDeleteTag.toggle()
                                    }
                                if showDeleteTag {
                                    Spacer()
                                    Button {
                                        student.removeFromTags(tag)
                                        do {
                                            try viewContext.save()
                                        }
                                        catch {
                                            print(error)
                                        }
                                        showDeleteTag.toggle()
                                    } label: {
                                        Label("", systemImage: "minus")
                                    }
                                }
                            }
                        }
                        .onDelete(perform: removeTag)
                        Picker("Add small group", selection: $newTag) {
                            Text("-----")
                            ForEach(allTags, id: \.self) { allTag in
                                Text(allTag.name ?? "")
                                    .tag(allTag)
                            }
                            //Text("Create New Tag")
                        }
                        .onChange(of: newTag) { newValue in
                            if userChange {
                                student.addToTags(newTag)
                                do {
                                    try viewContext.save()
                                }
                                catch {
                                    print(error)
                                }
                                newTag = Tag()
                                userChange = false
                            }
                            else {
                                userChange = true
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .fixedSize(horizontal: false, vertical: true)
                
                Divider()
                    .overlay(Color("PrimaryColor"))
                
                VStack (alignment: .leading) {
                    HStack {
                        Text("Prayer Requests")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button {
                            showingAddPrayerView.toggle()
                        } label: {
                            Label("", systemImage: "plus")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    ForEach(student.prayersArray) { prayer in
                        VStack (alignment: .leading) {
                            if prayer.hasDate {
                                let dT = prayer.dT!
                                Text(dT, formatter: dateFormat4)
                            }
                            Text(prayer.content ?? "")
                                .listRowSeparator(.visible)
                                .listRowSeparatorTint(.gray)
                            Divider()
                        }
                        .listRowSeparator(.visible)
                        .listRowSeparatorTint(.gray)
                        .onTapGesture {
                            prayerToEdit = prayer
                            showingEditPrayerView.toggle()
                        }
                    }
                }
                .padding()
                
                Divider()
                    .overlay(Color("PrimaryColor"))
                
                VStack (alignment: .leading){
                    HStack {
                        Text("Notes")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button {
                            showingAddNoteView.toggle()
                        } label: {
                            Label("", systemImage: "plus")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    ForEach(student.notesArray) { note in
                        VStack (alignment: .leading) {
                            if note.hasDate {
                                let dT = note.dT!
                                Text(dT, formatter: dateFormat4)
                            }
                            Text(note.content ?? "")
                            Divider()
                        }
                        .padding(10)
                        .onTapGesture {
                            noteToEdit = note
                            showingEditNoteView.toggle()
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(student.wrappedName)
        .navigationBarTitleDisplayMode(.inline)
        
        .sheet(isPresented: $showingAddNoteView) {
            AddNoteView(student: student)
        }
        .sheet(isPresented: $showingAddPrayerView) {
            AddPrayerView(student: student)
        }
        .sheet(isPresented: $showingEditStudentView) {
            EditStudentView(student: student)
        }
        .sheet(isPresented: $showingAddMeetingView) {
            AddMeetingView(student: student)
        }
        .sheet(isPresented: $showingEditPrayerView) {
            EditPrayerView(prayer: $prayerToEdit, student: student)
        }
        .sheet(isPresented: $showingEditNoteView) {
            EditNoteView(note: $noteToEdit, student: student)
        }
        .sheet(isPresented: $showingEditMeetingView) {
            EditMeetingView(meeting: $meetingToEdit, student: student)
        }
        .alert("Create new tag", isPresented: $showingCreateTag) {
            TextField("Tag Name", text: $tagName)
            Button("Submit", action: submitTag)
            Button("Cancel", role: .cancel) { }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingEditStudentView.toggle()
                } label: {
                    Text("Edit")
                }
            }
        }
        
        Spacer()
    }

    func removeTag( at offsets : IndexSet) {
        for offset in offsets {
            let tagToRemove = student.tagsArray[offset]
            student.removeFromTags(tagToRemove)
        }
        try? viewContext.save()
    }
//
    func submitTag() {
        let newTag2 = Tag(context: viewContext)
        newTag2.id = UUID()
        newTag2.name = tagName

        newTag = newTag2
        //student.addToTags(newTag)

        //tagName = ""

        //try? viewContext.save()
    }
//
//    /*func addTag() {
//        student.addToTags(newTag)
//        newTag = Tag()
//    }*/
}

