//
//  DayView.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//

import SwiftUI

struct DayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) var meetings: FetchedResults<Meeting>
    @FetchRequest(sortDescriptors: []) var prayers: FetchedResults<Prayer>
    @FetchRequest(sortDescriptors: []) var notes: FetchedResults<Note>
    
    //let now = Date()
    //let startofday = Calendar.current.startOfDay(for: now)
    
    //let Predicate = NSPredicate(format: "dT >= %@ and dT <= %@", startofday, endofday)
    //let Predicate = makePredicate()
    //@FetchRequest(sortDescriptors: [], predicate: Predicate) var meetings: FetchedResults<Meeting>
    
    var dateFormat1 = DateFormatter()
    
    init() {
        let startofday = Calendar.current.startOfDay(for: Date())
        let endofday = startofday.addingTimeInterval(86400)
        
        let PredicateMeetings = NSPredicate(format: "(dT >= %@) AND (dT <= %@)", startofday as CVarArg, endofday as CVarArg)
        let Predicate = NSPredicate(format: "(dT >= %@) AND (dT <= %@) AND (hasDate = true)", startofday as CVarArg, endofday as CVarArg)
        
        _meetings = FetchRequest<Meeting>(sortDescriptors: [SortDescriptor(\.dT)], predicate: PredicateMeetings)
        _prayers = FetchRequest<Prayer>(sortDescriptors: [], predicate: Predicate)
        _notes = FetchRequest<Note>(sortDescriptors: [], predicate: Predicate)
        
        dateFormat1.dateFormat = "h:mm a"
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Group {
                    Text(Date.now.formatted(Date.FormatStyle().weekday(.wide)))
                        .font(.largeTitle)
                        .offset(x: 15)
                    //Text(Date.now, format: .dateTime.month().day().year())
                    Text(Date.now.formatted(Date.FormatStyle().month(.wide).day().year()))
                        .font(.title2)
                        .offset(x: 20)
                }
                
                Divider()
                    .overlay(Color("PrimaryColor"))
                
                Text("Prayers Today")
                    .font(.headline)
                
                Divider()
                
                if prayers.isEmpty && notes.isEmpty {
                    Text("There are no prayer requests for today's date.")
                }
                else {
                    ForEach(prayers) { prayer in
                        NavigationLink {
                            StudentDetail(student: prayer.student!)
                        } label: {
                            PrayerRow(prayer: prayer)
                        }
                    }
                    ForEach(notes) { note in
                        NavigationLink {
                            StudentDetail(student: note.student!)
                        } label: {
                            NoteRow(note: note)
                        }
                    }
                }
                
                Divider()
                    .overlay(Color("PrimaryColor"))
                
                Text("Meetings Today")
                    .font(.headline)
                
                Divider()
                
                if meetings.isEmpty {
                    Text("There are no meetings scheduled for today.")
                }
                else {
                    ForEach(meetings) { meeting in
                        NavigationLink {
                            StudentDetail(student: meeting.student!)
                        } label: {
                            MeetingRow(meeting: meeting)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        
//        NavigationView {
//            List {
//                Section (header: Text("Prayer Requests Today")) {
//                    ForEach(prayers) { prayer in
//                        NavigationLink {
//                            StudentDetail(student: prayer.student!)
//                        } label: {
//                            Text(prayer.content ?? "")
//                        }
//                    }
//                    ForEach(notes) { note in
//                        NavigationLink {
//                            StudentDetail(student: note.student!)
//                        } label: {
//                            Text(note.content ?? "")
//                        }
//                    }
//                }
//            //}
//
//            //List {
//                Section (header: Text("Meetings Today")) {
//                    ForEach(meetings) { meeting in
//                        NavigationLink {
//                            StudentDetail(student: meeting.student!)
//                        } label: {
//                            let dT = meeting.dT!
//                            Text(meeting.student?.name ?? "Unknown")
//                            + Text(" at ")
//                            + Text(dT, formatter: dateFormat1)
//                        }
//                    }
//                }
//
//            }
//        }
    }
}
/*
func makePredicate() -> NSPredicate {
    let startofday = Calendar.current.startOfDay(for: Date())
    let endofday = startofday.addingTimeInterval(86400)
    
    return NSPredicate(formate: "(dT >= %@) AND (dT <= %@)", startofday, endofday)
}
*/
struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView()
    }
}

