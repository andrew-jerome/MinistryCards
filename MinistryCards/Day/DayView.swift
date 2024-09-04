//
//  DayView.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//

import SwiftUI
import CoreData

struct DayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) var meetings: FetchedResults<Meeting>
    @FetchRequest(sortDescriptors: []) var prayers: FetchedResults<Prayer>
    @FetchRequest(sortDescriptors: []) var prayersToday: FetchedResults<Prayer>
    @FetchRequest(sortDescriptors: []) var notes: FetchedResults<Note>
    @State private var numArray: [Int] = []
    
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
        _prayersToday = FetchRequest<Prayer>(sortDescriptors: [], predicate: Predicate)
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
                
                if prayers.isEmpty {
                    Text("There are no prayer requests.")
                }
                else if prayers.count <= 3 {
                    ForEach(prayers) { prayer in
                        NavigationLink {
                            StudentDetail(student: prayer.student!)
                        } label: {
                            PrayerRow(prayer: prayer)
                        }
                    }
                }
                else if numArray.count > 0 {
                    ForEach(0..<3) { index in
                        NavigationLink {
                            StudentDetail(student: prayers[numArray[index]].student!)
                        } label: {
                            PrayerRow(prayer: prayers[numArray[index]])
                        }
                    }
                }
                
                if !prayersToday.isEmpty || !notes.isEmpty {
                    Text("Prayers Scheduled Today")
                        .font(.headline)
                    
                    Divider()
                    
                    ForEach(prayersToday) { prayer in
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
                
                
                
//                if prayers.isEmpty && notes.isEmpty {
//                    Text("There are no prayer requests for today's date.")
//                }
//                else {
//                    ForEach(prayers) { prayer in
//                        NavigationLink {
//                            StudentDetail(student: prayer.student!)
//                        } label: {
//                            PrayerRow(prayer: prayer)
//                        }
//                    }
//                    ForEach(notes) { note in
//                        NavigationLink {
//                            StudentDetail(student: note.student!)
//                        } label: {
//                            NoteRow(note: note)
//                        }
//                    }
//                }
                
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
        .onAppear() {
            print(UserDefaults.standard.object(forKey: "LastOpened") as! Date)
            print(Date())
            let startofday = Calendar.current.startOfDay(for: Date())
            //if UserDefaults.standard.object(forKey: "LastOpened") as! Date != Date() {
            if UserDefaults.standard.object(forKey: "LastOpened") as! Date != startofday {
                if prayers.count > 2 {
                    for i in 0...2 {
                        print(i)
                        var flag = false
                        var newNum = 0
                        while flag == false {
                            flag = true
                            newNum = Int.random(in:0..<prayers.count)
                            if i != 0 {
                                for j in 0...(i-1) {
                                    if newNum == numArray[j] {
                                        print(10)
                                        flag = false
                                    }
                                }
                            }
                        }
                        numArray.append(newNum)
                    }
                }
                UserDefaults.standard.set(numArray, forKey: "PrayerIndices")
                UserDefaults.standard.set(startofday, forKey: "LastOpened")
                print(numArray)
            }
            else {
                print("test")
                numArray = UserDefaults.standard.array(forKey: "PrayerIndices") as? [Int] ?? [Int]()
            }
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

