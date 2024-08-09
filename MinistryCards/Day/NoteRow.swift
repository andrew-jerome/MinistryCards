//
//  NoteRow.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//

import SwiftUI

struct NoteRow: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(note.student!.wrappedName)
                .bold()
            Text(note.content ?? "")
            Divider()
        }
        .foregroundColor(.primary)
    }
}
