//
//  Caching.swift
//  AudioTranscriber
//
//  Created by sajeev Raj on 2/1/20.
//  Copyright © 2020 Transcriber. All rights reserved.
//

import Foundation

import Foundation
import RealmSwift
import Realm

protocol Caching {}

extension Caching where Self: BaseObject {
    
    func save() {
        DispatchQueue.main.async {
            DatabaseManager.shared.save(objects: [self])
        }
    }
    
    func delete() {
        DispatchQueue.main.async {
            DatabaseManager.shared.delete(objects: [self])
        }
    }
    
    // get all values from database
    static func cached() -> Self {
        return DatabaseManager.shared.getAll(type: self).first ?? Self()
    }
    
    static func allCaches() -> [Self] {
        return DatabaseManager.shared.getAll(type: self)
    }
    
    /// Update the object inside update handler
    func update(updateHandler: @escaping (Self) -> Void) {
        DispatchQueue.main.async {
            try? DatabaseManager.shared.database.write {
                    updateHandler(self)
            }
        }
    }
    
    static func find(predicate: NSPredicate) -> Self? {
        return DatabaseManager.shared.find(type: self, predicate: predicate)
    }
}

extension Array where Element: BaseObject {
    func saveAll() {
        DispatchQueue.main.async {
            DatabaseManager.shared.save(objects: self)
        }
    }
}
