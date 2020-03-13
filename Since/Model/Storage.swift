//
//  Storage.swift
//  Since
//
//  Created by Alok Karnik on 06/02/20.
//  Copyright © 2020 Alok Karnik. All rights reserved.
//

import Foundation
import SQLite3

struct Storage {
    fileprivate var db: OpaquePointer?
    private let queue = DispatchQueue(label: "DBSerialiser")

    init() {
        self.db = initStorage()
    }

    private mutating func initStorage() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent("activityStorage.sqlite")
        
        //Open database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return nil
        }
        return db
    }

    func createTable(createTableString: String) {
        queue.sync {
            _ = executeQuery(queryString: createTableString)
        }
    }

    func insert(insertString:String, success: @escaping () -> Void) {
        queue.async {
            if self.executeQuery(queryString: insertString) {
                DispatchQueue.main.async {
                    success()
                }
            }
        }
    }

    func update(updateString:String, success: @escaping () -> Void) {
        queue.async {
            if self.executeQuery(queryString: updateString) {
                DispatchQueue.main.async {
                    success()
                }
            }
        }
    }
    
    func delete(deleteString:String, success: @escaping () -> Void) {
        queue.async {
            if self.executeQuery(queryString: deleteString) {
                DispatchQueue.main.async {
                    success()
                }
            }
        }
    }

    func fetch(fetchString:String) -> [[String:Any]]? {
        var dataArray: [[String:Any]]? = nil
        queue.sync {
            var fetchStatement: OpaquePointer?
            if sqlite3_prepare(db, fetchString, -1, &fetchStatement, nil) == SQLITE_OK {
                while sqlite3_step(fetchStatement) == SQLITE_ROW {
                    let totalColumns = sqlite3_column_count(fetchStatement)
                    var row = [String:Any]()
                
                    for i in 0..<totalColumns {
                        let columnNameString = String.init(cString: sqlite3_column_name(fetchStatement, i))
                        let columnType = sqlite3_column_type(fetchStatement, i)

                        switch columnType {
                        case SQLITE_INTEGER:
                            let intValue = Int(sqlite3_column_int(fetchStatement, i))
                            row[columnNameString] = intValue

                        case SQLITE_TEXT:
                            let stringValue = String(cString: sqlite3_column_text(fetchStatement, i))
                            row[columnNameString] = stringValue

                        default:
                            break
                        }
                    }
                    if dataArray?.append(row) == nil {
                        dataArray = [row]
                    }
                }
            }
        }

        return dataArray
    }

    fileprivate func executeQuery(queryString:String) -> Bool {
        var queryStatement: OpaquePointer?
        var success = false
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                success = true
            }
        }
        sqlite3_finalize(queryStatement)

        return success
    }
}

