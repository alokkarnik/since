//
//  Activity.swift
//  Since
//
//  Created by Alok Karnik on 09/03/20.
//  Copyright © 2020 Alok Karnik. All rights reserved.
//

import Foundation

struct Activity {
    let id: Int
    let title: String
    var pastOccurences: [Date]

    init(id:Int, title: String, pastOccurences: [Date]) {
        self.id = id
        self.title = title
        self.pastOccurences = pastOccurences
    }
    
    var daysSinceLastOccurence: Int {
        get {
            if let lastOccuredDate = pastOccurences.last {
                let calendar = Calendar.current

                let today = calendar.startOfDay(for: Date())
                let date = calendar.startOfDay(for: lastOccuredDate)

                let components = calendar.dateComponents([.day], from: date, to: today)
                return components.day ?? 0
            }
            return 0
        }
    }
}
