//
//  BackendAPI.swift
//  IMDb - Tentwenty Assignment
//
//  Created by Shradha Bhagat on 23/04/22.
//

import Foundation
import Alamofire

enum BackendAPI{
    case getMovieList(page: Int)
    case getMovieDetails(movieID: Int)
    case getMovieTrailer(movieID: Int)
    
    private var baseURL: String {
        return  "https://api.themoviedb.org/3/"
    }
    
    var paramters: [String: Any]?{
        switch self{
        case .getMovieList(let page):
            return ["api_key": apiKey, "page": page]
        default:
            return ["api_key": apiKey]
        }
        
    }
    
    private var path: String{
        switch self{
        case .getMovieList:
            return "movie/upcoming"
        case .getMovieDetails(let movieID):
            return "movie/\(movieID)"
        case .getMovieTrailer(let movieID):
            return "movie/\(movieID)/videos"
        }
    }
    
    var url: URL?{
        return URL(string: baseURL + self.path)
    }
    
    private var apiKey: String {
        return  "7b277efb665b3a44e7d3bf3e31ff62a6"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    func makeRequest(completionHandler: @escaping (AFDataResponse<Data?>) -> Void) {
        guard let url = url else {
            return
        }
        AF.request(url, method: self.method, parameters: self.paramters).response{ response in
            completionHandler(response)
        }
    }
}
