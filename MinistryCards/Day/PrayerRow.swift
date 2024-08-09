//
//  PrayerRow.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//

import SwiftUI

struct PrayerRow: View {
    let prayer: Prayer
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(prayer.student!.wrappedName)
                .bold()
            Text(prayer.content ?? "")
            Divider()
        }
        .foregroundColor(.primary)
    }
}
