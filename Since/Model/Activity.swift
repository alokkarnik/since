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
    
}
