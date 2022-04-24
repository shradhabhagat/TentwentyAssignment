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
    let total_pages: Int?
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

// Movie Details Model
struct MovieDetails_Codable: Codable {
    let id: Int?
    let poster_path: String?
    let overview: String?
    let title: String?
    let release_date: String?
    var genres: [Genre_Codable]?
    
    enum CodingKeys: String, CodingKey {
            case genres, id
            case overview
            case poster_path = "poster_path"
            case release_date = "release_date"
            case title
        }
}

struct Genre_Codable: Codable {
    let id: Int?
    let name: String?
}

// Movie Trailer Model
struct Trailer_Codable: Codable {
    let id: Int?
    let results: [TrailerResult_Codable]?
}

struct TrailerResult_Codable: Codable {
    let key: String?
}
