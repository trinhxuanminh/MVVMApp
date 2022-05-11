//
//  MoviePopularUseCase.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import RxSwift
import SwinjectStoryboard

protocol MoviePopularUseCaseProtocol {
    func loadMoviePopular() -> Observable<[MovieViewModelProtocol]>
}

class MoviePopularUseCase: MoviePopularUseCaseProtocol {
    
    private var page: Int = 0
    private var totalPage: Int?
    private let movieRepository: MovieRepositoryProtocol
    
    init(movieRepository: MovieRepositoryProtocol) {
        self.movieRepository = movieRepository
    }
    
    func loadMoviePopular() -> Observable<[MovieViewModelProtocol]> {
        if self.totalPage != nil && self.page >= self.totalPage! {
            return Observable.never()
        }
        self.page += 1
        return self.movieRepository.loadList(input: .getPopular(page: self.page))
            .map { movieListOutput in
                self.totalPage = movieListOutput.total_pages
                return movieListOutput.movies.map { movie in
                    return MovieViewModel(movie: movie,
                                          disposeBag: SwinjectStoryboard.defaultContainer.resolve(DisposeBag.self)!,
                                          useCase: SwinjectStoryboard.defaultContainer.resolve(MovieUseCaseProtocol.self)!,
                                          navigator: SwinjectStoryboard.defaultContainer.resolve(MovieNavigatorProtocol.self)!)
                }
            }
    }
}
