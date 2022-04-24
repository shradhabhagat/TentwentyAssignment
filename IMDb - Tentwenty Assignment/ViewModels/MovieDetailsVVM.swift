//
//  MovieDetailsVVM.swift
//  IMDb - Tentwenty Assignment
//
//  Created by Shradha Bhagat on 23/04/22.
//

import Foundation
import RxSwift
import RxCocoa

class MovieDetailsVVM{
    private var movieId: Int!
    
    init(movieID: Int) {
        self.movieId = movieID
    }
    
    private let _movieDetail = BehaviorRelay<MovieDetails_Codable?>(value: nil)
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<String?>(value: nil)
    
    private let _movieTrailer = BehaviorRelay<TrailerResult_Codable?>(value: nil)
    
    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var error: Driver<String?> {
        return _error.asDriver()
    }
    
    var movieDetail: Driver<MovieDetails_Codable?> {
        return _movieDetail.asDriver()
    }
    
    var genres: [Genre_Codable]{
        return _movieDetail.value?.genres ?? []
    }
    
    var movieTrailer: Driver<TrailerResult_Codable?>{
        return _movieTrailer.asDriver()
    }
    
    
    public func fetchMovieDetail() {
        self._isFetching.accept(true)
        self._error.accept(nil)
        
        let backendService: BackendAPI = .getMovieDetails(movieID: self.movieId)
        backendService.makeRequest { response in
            self._isFetching.accept(false)
            switch response.result{
            case .success:
            do{
                let moviesDetailsResponse = try JSONDecoder().decode(MovieDetails_Codable.self, from: response.data!)
                self._movieDetail.accept(moviesDetailsResponse)
            } catch {
                self._error.accept(ErrorCodes.APIFailure.description)
            }
            case .failure:
                self._error.accept(ErrorCodes.APIFailure.description)
            }
        }
    }
    
    public func fetchMovieTrailer() {
        self._isFetching.accept(true)
        self._error.accept(nil)
        
        let backendService: BackendAPI = .getMovieTrailer(movieID: self.movieId)
        backendService.makeRequest { response in
            self._isFetching.accept(false)
            switch response.result{
            case .success:
            do{
                let moviesTrailerResponse = try JSONDecoder().decode(Trailer_Codable.self, from: response.data!)
                self._movieTrailer.accept(moviesTrailerResponse.results?.first)
            } catch {
                self._error.accept(ErrorCodes.APIFailure.description)
            }
            case .failure:
                self._error.accept(ErrorCodes.APIFailure.description)
            }
        }
    }
}
