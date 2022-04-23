//
//  RealmDB.swift
//  IMDb - Tentwenty Assignment
//
//  Created by Shradha Bhagat on 23/04/22.
//

import UIKit
import RealmSwift

class RealmDB {
    static let shared = RealmDB()
    
    private var storage: Realm?
    
    private init() {
        let realm = Realm.Configuration()
        storage = try! Realm.init(configuration: realm)
    }
    
    func addData(newObjects: [Object]) {
        try! storage?.write {
            storage?.add(newObjects, update: .modified)
        }
    }
    
    func deleteRecords()  {
        try! storage?.write {
            storage?.deleteAll()
        }
    }
    
    func getMoviesData() -> Results<MovieItem_Codable>? {
        let results = storage?.objects(MovieItem_Codable.self)
        return results
    }
    
}


