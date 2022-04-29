//
//  FavoriteUseCase.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import RxSwift

protocol FavoriteUseCaseType {
    func fetchFavorite() -> Observable<[MovieViewModel]>
}

class FavoriteUseCase: FavoriteUseCaseType {
    
    private let movieRepository = MovieRepository()
    
    func fetchFavorite() -> Observable<[MovieViewModel]> {
        return self.movieRepository.fetchFavorite().map { movies in
            return movies.reversed().map { movie in
                return MovieViewModel(movie: movie)
            }
        }
    }
}
