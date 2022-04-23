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
    
    private let _successResponse = BehaviorRelay<AllMoviesList_Codable?>(value: nil)
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<String?>(value: nil)
    
    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var error: Driver<String?> {
        return _error.asDriver()
    }
    
    var successResponse: Driver<AllMoviesList_Codable?> {
        return _successResponse.asDriver()
    }
    
    public func fetchAllMovies() {
        self._isFetching.accept(true)
        self._error.accept(nil)
        
        let backendService: BackendAPI = .getMovieList
        backendService.makeRequest { response in
            switch response.result{
            case .success:
            do{
                let moviesResponse = try JSONDecoder().decode(AllMoviesList_Codable.self, from: response.data!)
                self._successResponse.accept(moviesResponse)
            } catch {
                print("Error decoding data")
            }
            case .failure:
                print("API Error")
            }
        }
    }
    
}
