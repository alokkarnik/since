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
    var pastOccurencesToDisplay: [Date]

    init(id: Int, title: String, pastOccurences: [Date]) {
        self.id = id
        self.title = title
        self.pastOccurences = pastOccurences
        pastOccurencesToDisplay = pastOccurences.reversed()
    }

    var daysSinceLastOccurence: Int {
        if let lastOccuredDate = pastOccurences.last {
            return lastOccuredDate.differenceInDaysFrom(Date())
        }
        return 0
    }

    mutating func saveUpdates() {
        pastOccurences = pastOccurencesToDisplay.reversed()
    }

    mutating func resetUpdates() {
        pastOccurencesToDisplay = pastOccurences.reversed()
    }
}

extension Date {
    func differenceInDaysFrom(_ otherDate: Date) -> Int {
        let calendar = Calendar.current

        let today = calendar.startOfDay(for: otherDate)
        let date = calendar.startOfDay(for: self)

        let components = calendar.dateComponents([.day], from: date, to: today)
        return components.day ?? 0
    }
}
