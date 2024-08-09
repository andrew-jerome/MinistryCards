//
//  MeetingRow.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//

import SwiftUI

struct MeetingRow: View {
    let meeting: Meeting
    
    var body: some View {
        VStack(alignment: .leading) {
            let dT = meeting.dT!
            Text(meeting.student!.wrappedName)
                .bold()
            if meeting.location != "" {
                Text(dT.formatted(Date.FormatStyle().hour(.defaultDigits(amPM: .abbreviated)).minute(.twoDigits)))
                + Text(" at " + (meeting.location ?? ""))
            }
            else {
                Text(dT.formatted(Date.FormatStyle().hour(.defaultDigits(amPM: .abbreviated)).minute(.twoDigits)))
            }
            Divider()
        }
        .foregroundColor(.primary)
    }
}
