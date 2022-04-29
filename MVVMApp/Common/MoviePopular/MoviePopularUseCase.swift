//
//  MoviePopularUseCase.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import RxSwift

protocol MoviePopularUseCaseType {
    func loadMoviePopular() -> Observable<[MovieViewModel]>
}

class MoviePopularUseCase: MoviePopularUseCaseType {
    
    private let movieRepository = MovieRepository()
    private var page: Int = 0
    private var totalPage: Int?
    
    func loadMoviePopular() -> Observable<[MovieViewModel]> {
        if self.totalPage != nil && self.page >= self.totalPage! {
            return Observable.never()
        }
        self.page += 1
        return self.movieRepository.loadList(input: .getPopular(page: self.page))
            .map { movieListOutput in
                self.totalPage = movieListOutput.total_pages
                return movieListOutput.movies.map { movie in
                    return MovieViewModel(movie: movie)
                }
            }
    }
}
