//
//  ListView.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//

import SwiftUI
import CoreData

struct ListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var students: FetchedResults<Student>
    @FetchRequest(sortDescriptors: []) var tags: FetchedResults<Tag>
    
    @State private var filterPredicate = NSPredicate(value: true)
    @State private var searchPredicate = NSPredicate(value: true)
    
    @State private var showingAddStudentView = false
    
    enum SearchScopes {
        case name
        case major
        case notes
    }
    
    let years = ["Freshman", "Sophomore", "Junior", "Senior", "Other"]
    let sorts = ["Name (Ascending)", "Name (Descending)", "Last Meeting (Recent First)", "Last Meeting (Oldest First)"]
    
    @State private var selectedSort = ""
    @State private var searchScope = SearchScopes.name
    
    @State private var selectedFilter = ""
    var filterQuery: Binding<String> {
        Binding {
            selectedFilter
        } set: { newValue in
            selectedFilter = newValue
            if newValue.isEmpty || newValue == "None" {
                filterPredicate = NSPredicate(value: true)
            }
            else if newValue == "Freshman" || newValue == "Sophomore" || newValue == "Junior" || newValue == "Senior" || newValue == "Other" {
                filterPredicate = NSPredicate(format: "year LIKE %@", newValue)
            }
            else {
                filterPredicate = NSPredicate(format: "%@ in tags.name", newValue)
            }
            students.nsPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [filterPredicate, searchPredicate])
        }
    }
    
    @State private var searchText = ""
    var query: Binding<String> {
        Binding {
            searchText
        } set: { newValue in
            searchText = newValue
//            students.nsPredicate = newValue.isEmpty
//            ? nil
//            : NSPredicate(format: "name CONTAINS[c] %@", newValue)
            switch searchScope {
            case .name:
                searchPredicate = newValue.isEmpty
                ? NSPredicate(value: true)
                : NSPredicate(format: "name CONTAINS[c] %@", newValue)
                students.nsPredicate =
                    NSCompoundPredicate(andPredicateWithSubpredicates: [filterPredicate, searchPredicate])
            case .major:
                searchPredicate = newValue.isEmpty
                ? NSPredicate(value: true)
                : NSPredicate(format: "degree CONTAINS[c] %@", newValue)
                students.nsPredicate =
                    NSCompoundPredicate(andPredicateWithSubpredicates: [filterPredicate, searchPredicate])
            case .notes:
                searchPredicate = newValue.isEmpty
                ? NSPredicate(value: true)
                : NSPredicate(format: "notes.content CONTAINS[c] %@ OR prayers.content CONTAINS[c] %@", newValue, newValue)
                students.nsPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [filterPredicate, searchPredicate])
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            //List {
            ScrollView {
                ForEach(students) { student in
                    NavigationLink {
                        StudentDetail(student: student)
                    } label: {
                        StudentRow(student: student)
                    }
                }
                
                Spacer()
            }
            .padding()
           // }
            .onAppear {
                for student in students {
                    if student.hasMet {
                        for meeting in student.meetingsArray {
                            if (meeting.dT ?? Date.now) < Date.now && (meeting.dT ?? Date.now) > (student.lastMeeting?.dT ?? Date.now) {
                                student.lastMeeting = meeting
                            }
                        }
                    }
                    else {
                        for meeting in student.meetingsArray {
                            if (meeting.dT ?? Date.now) < Date.now {
                                student.lastMeeting = meeting
                                student.hasMet = true
                                break
                            }
                        }
                    }
                }
            }
            
//            .navigationDestination(for: Student.self) { student in
//                StudentDetail(student: student)
//            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Students")
                        .font(.title)
                        .bold()
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddStudentView.toggle()
                    } label: {
                        Label("Add Student", systemImage: "plus")
                            .foregroundColor(Color("PrimaryColor"))
                    }
                }
                ToolbarItemGroup(placement: .secondaryAction) {
                    Picker("Sort", selection: $selectedSort) {
                        ForEach(sorts, id: \.self) {
                            Text($0)
                        }
                    }
                    .onChange(of: selectedSort) { value in
                        selectedSort = value
                        
                        if selectedSort == "Name (Ascending)" {
                            students.sortDescriptors = [SortDescriptor(\Student.name, order: .forward)]
                        }
                        else if selectedSort == "Name (Descending)" {
                            students.sortDescriptors = [SortDescriptor(\Student.name, order: .reverse)]
                        }
                        else if selectedSort == "Last Meeting (Recent First)" {
                            students.sortDescriptors = [SortDescriptor(\Student.lastMeeting?.dT, order: .reverse)]
                        }
                        else if selectedSort == "Last Meeting (Oldest First)" {
                            students.sortDescriptors = [SortDescriptor(\Student.lastMeeting?.dT, order: .forward)]
                        }
                    }
                    Picker("Filter (Year)", selection: filterQuery) {
                        Text("None").tag("None")
                        ForEach(years, id: \.self) {
                            Text($0)
                        }
                    }
                    Picker("Filter (Small Groups)", selection: filterQuery) {
                        Text("None").tag("None")
                        ForEach(tags) { tag in
                            Text(tag.name ?? "")
                                .tag(tag.name ?? "")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddStudentView) {
                AddStudentView()
            }
            .navigationBarTitleDisplayMode(.inline)
            //.toolbarBackground(.visible, for: .navigationBar)
            //.toolbarBackground(Color("PrimaryColor"), for: .navigationBar)
        }
        .searchable(text: query)
        .searchScopes($searchScope, activation: .onSearchPresentation) {
            Text("Name").tag(SearchScopes.name)
            Text("Major").tag(SearchScopes.major)
            Text("Notes").tag(SearchScopes.notes)
        }
            /*List {
                ForEach(students) { student in
                    Text(student.name ?? "Unknown")
                }
            }*/
  /*      NavigationView {
            List {
                ForEach(students) { student in
                    NavigationLink {
                        Text("student.name")
                    }
                }
       //         .onDelete(perform: //deleteItems)
            }
   */
      /*      .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
       */
    }
/*
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
 */
/*
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
 */
}
/*
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()*/

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
      //  ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        ListView()
    }
}
/*
 struct ContentView: View {
 var body: some View {
 VStack {
 Image(systemName: "globe")
 .imageScale(.large)
 .foregroundColor(.accentColor)
 Text("Hello, world!")
 }
 }
 }
 
 struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 ContentView()
 }
 }
 */

