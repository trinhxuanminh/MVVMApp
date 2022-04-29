//
//  HomeUseCase.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import RxSwift

protocol HomeUseCaseType {
    func loadMovieNowPlaying() -> Observable<[MovieViewModel]>
}

class HomeUseCase: HomeUseCaseType {
    
    private let movieRepository = MovieRepository()
    
    func loadMovieNowPlaying() -> Observable<[MovieViewModel]> {
        return self.movieRepository.loadList(input: .getNowPlaying(page: 1)).map { movieListOutput in
            return movieListOutput.movies.map { movie in
                return MovieViewModel(movie: movie)
            }
        }
    }
}
