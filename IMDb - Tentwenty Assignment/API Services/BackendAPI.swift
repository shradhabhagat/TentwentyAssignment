//
//  BackendAPI.swift
//  IMDb - Tentwenty Assignment
//
//  Created by Shradha Bhagat on 23/04/22.
//

import Foundation
import Alamofire

enum BackendAPI{
    case getMovieList
    case getMovieDetails(movieID: Int)
    case getMovieTrailer(movieID: Int)
    
    private var baseURL: String {
        return  "https://api.themoviedb.org/3/"
    }
    
    private var apiKey: String {
        return  "1174629886ef65a9e006dc7bac9ce18a"
    }
    
    var paramters: [String: Any]?{
        return ["api_key": apiKey]
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
