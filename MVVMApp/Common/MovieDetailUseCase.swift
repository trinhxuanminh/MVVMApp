//
//  MovieDetailUseCase.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import RxSwift

protocol MovieDetailUseCaseProtocol {
    func loadMovieDetail(_ movie: Movie) -> Observable<MovieDetail>
}

class MovieDetailUseCase: MovieDetailUseCaseProtocol {
    
    private let movieRepository: MovieRepositoryProtocol
    
    init(movieRepository: MovieRepositoryProtocol) {
        self.movieRepository = movieRepository
    }
    
    func loadMovieDetail(_ movie: Movie) -> Observable<MovieDetail> {
        return self.movieRepository.loadDetail(input: .getDetail(id: movie.id!, page: 1)).map { movieDetailOutput in
            return movieDetailOutput.movieDetail
        }
    }
}
