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
    var daysSinceLastDone: Int
    
    init(id:Int, title: String, daysSinceLastDone: Int) {
        self.id = id
        self.title = title
        self.daysSinceLastDone = daysSinceLastDone
    }
    
}
