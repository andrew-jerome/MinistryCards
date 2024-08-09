//
//  StudentRow.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//

import SwiftUI

struct StudentRow: View {
    let student: Student
    
    var dateFormat1 = DateFormatter()
    
    init (student: Student) {
        self.student = student
        dateFormat1.dateFormat = "MMMM dd, yyyy"
    }
    
    var body: some View {
        let dT = student.lastMeeting?.dT ?? Date.now
        VStack(alignment: .leading) {
            Text(student.wrappedName)
                .font(.headline)
            HStack {
                if student.hasMet {
                    Text("Last Meeting: ")
                    + Text(dT, formatter: dateFormat1)
                }
                else {
                    Text("Last Meeting: None")
                }
            }
                .offset(x: 10)
            Divider()
        }
        .foregroundColor(.primary)
    }
}
