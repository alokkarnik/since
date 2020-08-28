//
//  ActivityStorageController.swift
//  Since
//
//  Created by Alok Karnik on 09/03/20.
//  Copyright © 2020 Alok Karnik. All rights reserved.
//

import Foundation

protocol ActivityDataProtocol {}

struct ActivityStorageController {
    private var storage = Storage(databaseName: "activityStorage")
    static var sharedStorage = ActivityStorageController()

    private init() {
        initializeStorage()
    }

    fileprivate func initializeStorage() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS activities(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name text,
        occurrences text);
        """
        _ = storage.createTable(createTableString: createTableString)
    }

    func getAllActivities() -> [Activity]? {
        var activities: [Activity]?

        let fetchAllActivitiesString = """
        SELECT * FROM activities;
        """

        if let storedActivites = storage.fetch(fetchString: fetchAllActivitiesString) {
            activities = [Activity]()
            for storeActivity in storedActivites {
                if let occurencesArr = arr(fromJson: storeActivity["occurrences"] as! String) as? [String] {
                    var activity = Activity(id: storeActivity["id"] as! Int,
                                            title: storeActivity["name"] as! String,
                                            pastOccurences: occurencesArr.map { $0.toDate()! })
                    activity.pastOccurences = activity.pastOccurences.sorted(by: { $0.compare($1) == .orderedAscending })
                    if activities?.append(activity) == nil {
                        activities = [activity]
                    }
                }
            }
        }
        return activities?.sorted(by: { $0.daysSinceLastOccurence < $1.daysSinceLastOccurence })
    }

    func getActivity(withID id: Int) -> Activity? {
        var activity: Activity?

        let fetchActivitiesString = """
        SELECT * FROM activities WHERE id = '\(id)';
        """

        if let storedActivites = storage.fetch(fetchString: fetchActivitiesString) {
            for storeActivity in storedActivites {
                if let occurencesArr = arr(fromJson: storeActivity["occurrences"] as! String) as? [String] {
                    activity = Activity(id: storeActivity["id"] as! Int,
                                        title: storeActivity["name"] as! String,
                                        pastOccurences: occurencesArr.map { $0.toDate()! })
                }
            }
        }
        return activity
    }

    func insertActivity(activityTitle: String, date: Date) {
        if let dateString = date.toString(), let jsonstr = json(from: [dateString]) {
            let insertActivityStatement = """
            INSERT INTO activities(name, occurrences)
            values(?,?);
            """
            storage.insert(insertString: insertActivityStatement, parameters: [activityTitle, jsonstr])
            notify()
        }
    }

    func update(activity: Activity, date: Date?) {
        var updatedOccurences = activity.pastOccurences.map { $0.toString() }
        if let date = date {
            updatedOccurences.append(date.toString())
        }
        if let jsonString = json(from: updatedOccurences as [Any]) {
            let updateActivityStatement = """
            UPDATE activities SET occurrences = ? WHERE id = ?;
            """
            _ = storage.update(updateString: updateActivityStatement, parameters: [jsonString, activity.id])
            notify()
        }
    }

    func delete(activity: Activity) {
        let deleteActivityStatement = """
            DELETE FROM activities where id = '\(activity.id)';
        """

        storage.delete(deleteString: deleteActivityStatement)
        notify()
    }

    func notify() {
        let nc = NotificationCenter.default
        nc.post(name: NSNotification.Name(rawValue: "dataUpdated"), object: nil)
    }
}

extension ActivityStorageController {
    func json(from object: [Any]) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }

    func arr(fromJson: String) -> [Any]? {
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
