//
//  FavoriteUseCase.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import RxSwift

protocol FavoriteUseCaseProtocol {
    func fetchFavorite() -> Observable<[MovieAnimated]>
}

class FavoriteUseCase: FavoriteUseCaseProtocol {
    
    private let movieRepository: MovieRepositoryProtocol
    
    init(movieRepository: MovieRepositoryProtocol) {
        self.movieRepository = movieRepository
    }
    
    func fetchFavorite() -> Observable<[MovieAnimated]> {
        return self.movieRepository.fetchFavorite().map { movies in
            return movies.reversed().map { movie in
                return MovieAnimated(movie: movie)
            }
        }
    }
}
