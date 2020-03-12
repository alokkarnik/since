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
            CREATE TABLE IF NOT EXISTS activities(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name text,
            occurrences text);
            """
        storage.createTable(createTableString: createTableString)
    }
    
    func getAllActivities() -> [Activity]? {
        var activities: [Activity]? = nil

        let fetchAllActivitiesString = """
            SELECT * FROM activities ORDER BY id DESC;
            """

        if let storedActivites = storage.fetch(fetchString: fetchAllActivitiesString) {
            activities = [Activity]()
            for storeActivity in storedActivites {
                if let occurencesArr = arr(fromJson: storeActivity["occurrences"] as! String) as? [String] {
                    let activity = Activity(id: storeActivity["id"] as! Int,
                                                title:storeActivity["name"] as! String,
                                                pastOccurences: occurencesArr.map{$0.toDate()!})

                        if activities?.append(activity) == nil {
                            activities = [activity]
                    }
                }
            }
        }
        return activities

    }
    
    func insertActivity(activityTitle: String, date: Date) {
        
        if let dateString = date.toString(), let jsonstr = json(from: [dateString]) {
            let insertActivityStatement = """
                INSERT INTO activities(name, occurrences)
                values('\(activityTitle)',
                '\(jsonstr)');
                """
            storage.insert(insertString: insertActivityStatement)
        }
    }
    
    func update(activity: Activity, date: Date) {
        var updatedOccurences = activity.pastOccurences.map{$0.toString()}
        updatedOccurences.append(date.toString())
        if let jsonString = json(from: updatedOccurences as [Any]) {
            let updateActivityStatement = """
            UPDATE activities SET occurrences = '\(jsonString)' WHERE id = '\(activity.id)';
            """
            storage.update(updateString: updateActivityStatement)
        }
    }
}


extension ActivityStorageController {
    func json(from object:[Any]) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }

    func arr(fromJson:String) -> [Any]? {
        if let jsonData = fromJson.data(using: .utf8) {
            do {
                    return try JSONSerialization.jsonObject(with: jsonData, options: []) as? [Any]
                } catch {
                    return nil
                }
            }
        return nil
    }
}

extension Date {
    func toString() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let stringDate: String = formatter.string(from: self)
        
        return stringDate
    }
}

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateFromString: Date? = dateFormatter.date(from: self)
        
        return dateFromString
    }
}
