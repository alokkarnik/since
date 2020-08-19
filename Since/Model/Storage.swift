//
//  Storage.swift
//  Since
//
//  Created by Alok Karnik on 06/02/20.
//  Copyright © 2020 Alok Karnik. All rights reserved.
//

import Foundation
import SQLite3
let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

public struct Storage {
    fileprivate var db: OpaquePointer?
    fileprivate let databaseName: String

    private let queue = DispatchQueue(label: "sqlHelperQueue",
                                      qos: .utility,
                                      attributes: .concurrent)

    public init(databaseName: String) {
        self.databaseName = databaseName
        db = initStorage()
    }

    private mutating func initStorage() -> OpaquePointer? {
        let fileURL = getStoragePath()

        // Open database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return nil
        }
        return db
    }

    public func createTable(createTableString: String) -> Bool {
        return queue.sync(flags: .barrier) {
            executeQuery(queryString: createTableString)
        }
    }

    @discardableResult public func insert(insertString: String, parameters: [Any?]) -> Bool {
        var queryStatement: OpaquePointer?
        var success = false
        if sqlite3_prepare_v2(db, insertString, -1, &queryStatement, nil) == SQLITE_OK {
            for (index, value) in parameters.enumerated() {
                if let value = value as? Int {
                    sqlite3_bind_int(queryStatement, Int32(index + 1), Int32(value))
                } else if let value = value as? String {
                    sqlite3_bind_text(queryStatement, Int32(index + 1), String(utf8String: value), -1, SQLITE_TRANSIENT)
                } else if let value = value as? [Any] {
                    if let jsonStr = jsonString(from: value) {
                        sqlite3_bind_text(queryStatement, Int32(index + 1), String(utf8String: jsonStr), -1, SQLITE_TRANSIENT)
                    }
                } else if let value = value as? Double {
                    sqlite3_bind_double(queryStatement, Int32(index + 1), value)
                } else if let value = value as? Bool {
                    let intVal = value ? 1 : 0
                    sqlite3_bind_int(queryStatement, Int32(index + 1), Int32(intVal))
                } else {
                    sqlite3_bind_null(queryStatement, Int32(index + 1))
                }
            }

            if sqlite3_step(queryStatement) == SQLITE_DONE {
                success = true
            }
        }
        sqlite3_finalize(queryStatement)
        return success
    }

    public func update(updateString: String, parameters: [Any?]) -> Bool {
        var queryStatement: OpaquePointer?
        var success = false
        if sqlite3_prepare_v2(db, updateString, -1, &queryStatement, nil) == SQLITE_OK {
            for (index, value) in parameters.enumerated() {
                if let value = value as? Int {
                    sqlite3_bind_int(queryStatement, Int32(index + 1), Int32(value))
                } else if let value = value as? String {
                    sqlite3_bind_text(queryStatement, Int32(index + 1), String(utf8String: value), -1, SQLITE_TRANSIENT)
                } else if let value = value as? [Any] {
                    if let jsonStr = jsonString(from: value) {
                        sqlite3_bind_text(queryStatement, Int32(index + 1), String(utf8String: jsonStr), -1, SQLITE_TRANSIENT)
                    }
                } else if let value = value as? Double {
                    sqlite3_bind_double(queryStatement, Int32(index + 1), value)
                } else if let value = value as? Bool {
                    let intVal = value ? 1 : 0
                    sqlite3_bind_int(queryStatement, Int32(index + 1), Int32(intVal))
                } else {
                    sqlite3_bind_null(queryStatement, Int32(index + 1))
                }
            }

            if sqlite3_step(queryStatement) == SQLITE_DONE {
                success = true
            }
        }
        sqlite3_finalize(queryStatement)
        return success
    }

    public func delete(deleteString: String) {
        return queue.sync(flags: .barrier) {
            executeQuery(queryString: deleteString)
        }
    }

    public func fetch(fetchString: String) -> [[String: Any]]? {
        var dataArray: [[String: Any]]?
        queue.sync {
            var fetchStatement: OpaquePointer?
            if sqlite3_prepare(db, fetchString, -1, &fetchStatement, nil) == SQLITE_OK {
                while sqlite3_step(fetchStatement) == SQLITE_ROW {
                    let totalColumns = sqlite3_column_count(fetchStatement)
                    var row = [String: Any]()

                    for i in 0 ..< totalColumns {
                        let columnNameString = String(cString: sqlite3_column_name(fetchStatement, i))
                        let columnType = sqlite3_column_type(fetchStatement, i)

                        switch columnType {
                        case SQLITE_INTEGER:
                            let intValue = Int(sqlite3_column_int(fetchStatement, i))
                            row[columnNameString] = intValue

                        case SQLITE_TEXT:
                            let stringValue = String(cString: sqlite3_column_text(fetchStatement, i))
                            row[columnNameString] = stringValue

                        case SQLITE_FLOAT:
                            let realValue = Double(sqlite3_column_int(fetchStatement, i))
                            row[columnNameString] = realValue

                        case SQLITE_NULL:
                            row[columnNameString] = nil
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

    public func destroyStorage() {
        try? FileManager.default.removeItem(atPath: getStoragePath().path)
    }

    @discardableResult fileprivate func executeQuery(queryString: String) -> Bool {
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

    fileprivate func getStoragePath() -> URL {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("\(databaseName).sqlite")

        return fileURL
    }

    fileprivate func jsonString(from object: Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            print(object)
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}
