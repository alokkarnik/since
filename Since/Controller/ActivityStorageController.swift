//
//  ActivityStorageController.swift
//  Since
//
//  Created by Alok Karnik on 09/03/20.
//  Copyright © 2020 Alok Karnik. All rights reserved.
//

import Foundation

struct ActivityStorageController {
    var storage = Storage()
    
    init() {
        initializeStorage()
    }
    
    fileprivate func initializeStorage() {
        let createTableString = """
            CREATE TABLE IF NOT EXISTS Activities(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name text,
            daysSinceLastDone integer);
            """
        storage.createTable(createTableString: createTableString)
    }
    
    func getAllActivities() -> [Activity]? {
        var activities: [Activity]? = nil

        let fetchAllActivitiesString = """
            SELECT * FROM Activities ORDER BY id DESC;
            """

        if let storedActivites = storage.fetch(fetchString: fetchAllActivitiesString) {
            activities = [Activity]()
            for storeActivity in storedActivites {
                let activity = Activity(id: storeActivity["id"] as! Int,
                                        title:storeActivity["name"] as! String,
                                        daysSinceLastDone: storeActivity["daysSinceLastDone"] as! Int)
                if activities?.append(activity) == nil {
                    activities = [activity]
                }
            }
        }
        
        return activities
    }
    
    func insertActivity(activityTitle: String) {
        
        let insertActivityString = """
            INSERT INTO Activities(name, daysSinceLastDone)
            values("\(activityTitle)", "0");
            """
        storage.insert(insertString: insertActivityString)

    }
}
