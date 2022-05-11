//
//  MovieUseCase.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import RxSwift

protocol MovieUseCaseProtocol {
    func isFavorite(_ movie: Movie) -> Bool
    func deleteFavorite(_ movie: Movie)
    func setFavorite(_ movie: Movie) -> Bool
}

class MovieUseCase: MovieUseCaseProtocol {
    
    private let movieRepository: MovieRepositoryProtocol
    
    init(movieRepository: MovieRepositoryProtocol) {
        self.movieRepository = movieRepository
    }
    
    func isFavorite(_ movie: Movie) -> Bool {
        return self.movieRepository.isFavorite(movie)
    }
    
    func deleteFavorite(_ movie: Movie) {
        self.movieRepository.deleteFavorite(movie)
    }
    
    func setFavorite(_ movie: Movie) -> Bool {
        let isFavorite = self.movieRepository.isFavorite(movie)
        isFavorite ? self.movieRepository.deleteFavorite(movie) : self.movieRepository.addFavorite(movie)
        return isFavorite
    }
}
