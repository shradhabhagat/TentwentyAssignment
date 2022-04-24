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
    private let _searchedMovieItems = BehaviorRelay<[MovieItem_Codable]?>(value: nil)
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
    var searchMovieItems: Driver<[MovieItem_Codable]?> {
        return _searchedMovieItems.asDriver()
    }
    
    var dataSource: [MovieItem_Codable] {
        return _movieItems.value?.items ?? []
    }
    
    var searchDataSource: [MovieItem_Codable]? {
        return _searchedMovieItems.value ?? _movieItems.value?.items
    }
    
    private var page = 1
    private var totalPages = 2
    
    func filterResultsBySearch(str: String?){
        if let str = str, !str.isEmpty {
            let movies = self.dataSource.filter({($0.title ?? "").lowercased().contains(str.lowercased()) })
            self._searchedMovieItems.accept(movies)
        } else{
            self._searchedMovieItems.accept(nil)
        }
    }
    
    public func fetchNextPage(){
        if self.page < self.totalPages{
            self.fetchAllMovies(page: self.page + 1)
        }
    }
    
    public func fetchAllMovies(page: Int = 1) {
        if page == 1{
            self._isFetching.accept(true)
        }
        self._error.accept(nil)
        
        let backendService: BackendAPI = .getMovieList(page: page)
        backendService.makeRequest { response in
            self._isFetching.accept(false)
            switch response.result{
            case .success:
            do{
                let moviesResponse = try JSONDecoder().decode(AllMoviesList_Codable.self, from: response.data!)
                if page == 1{
                    RealmDB.shared.deleteRecords()
                }
                self.page = moviesResponse.page ?? page
                self.totalPages = moviesResponse.total_pages ?? self.totalPages
                if let movies = moviesResponse.results{
                    RealmDB.shared.addData(newObjects: movies)
                    if let records = RealmDB.shared.getMoviesData(){
                        self._movieItems.accept((items: Array(records), isOffline: false))
                    }
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
