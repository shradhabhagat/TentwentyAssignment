//
//  MoviesVVM.swift
//  IMDb - Tentwenty Assignment
//
//  Created by Shradha Bhagat on 23/04/22.
//

import Foundation
import RxSwift
import RxCocoa

class MoviesVVM{
    init() {
    }
    
    private let _movieItems = BehaviorRelay<(items: [MovieItem_Codable], isOffline: Bool)?>(value: nil)
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<String?>(value: nil)
    
    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var error: Driver<String?> {
        return _error.asDriver()
    }
    
    var movieItems: Driver<(items: [MovieItem_Codable], isOffline: Bool)?> {
        return _movieItems.asDriver()
    }
    
    var dataSource: [MovieItem_Codable] {
        return _movieItems.value?.items ?? []
    }
    
    public func fetchAllMovies() {
        self._isFetching.accept(true)
        self._error.accept(nil)
        
        let backendService: BackendAPI = .getMovieList
        backendService.makeRequest { response in
            self._isFetching.accept(false)
            switch response.result{
            case .success:
            do{
                let moviesResponse = try JSONDecoder().decode(AllMoviesList_Codable.self, from: response.data!)
                RealmDB.shared.deleteRecords()
                if let movies = moviesResponse.results{
                    RealmDB.shared.addData(newObjects: movies)
                    self._movieItems.accept((items: movies, isOffline: false))
                }
            } catch {
                
                if let movies = RealmDB.shared.getMoviesData(), movies.count > 0{
                    self._movieItems.accept((items: Array(movies), isOffline: true))
                } else{
                    self._error.accept(ErrorCodes.APIFailure.description)
                }
            }
            case .failure:
                self._error.accept(ErrorCodes.APIFailure.description)
                if let movies = RealmDB.shared.getMoviesData(), movies.count > 0{
                    self._movieItems.accept((items: Array(movies), isOffline: true))
                } else{
                    self._error.accept(ErrorCodes.APIFailure.description)
                }
            }
        }
    }
}
