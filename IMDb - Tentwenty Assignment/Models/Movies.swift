//
//  Movies.swift
//  IMDb - Tentwenty Assignment
//
//  Created by Shradha Bhagat on 23/04/22.
//

import Foundation
import RealmSwift


struct AllMoviesList_Codable: Codable {
    let page: Int?
    let totalPages: Int?
    var results: [MovieItem_Codable]?
}

//REALM OBJECT CLASS
class MovieItem_Codable: Object, Codable {
    @objc dynamic var title, poster_path: String?
    @objc dynamic var id : Int
    enum CodingKeys: String, CodingKey {
        case id, title, poster_path
    }
    
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    public static func ==(lhs: MovieItem_Codable, rhs: MovieItem_Codable) -> Bool {
        return lhs.id == rhs.id
    }
}
