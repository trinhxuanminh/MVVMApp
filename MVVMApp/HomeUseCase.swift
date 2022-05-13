//
//  HomeUseCase.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import RxSwift
import Swinject

protocol HomeUseCaseProtocol {
    func loadMovieNowPlaying() -> Observable<[MovieViewModelProtocol]>
}

class HomeUseCase: HomeUseCaseProtocol {
    
    private let movieRepository: MovieRepositoryProtocol
    
    init(movieRepository: MovieRepositoryProtocol) {
        self.movieRepository = movieRepository
    }
    
    func loadMovieNowPlaying() -> Observable<[MovieViewModelProtocol]> {
        return self.movieRepository.loadList(input: .getNowPlaying(page: 1)).map { movieListOutput in
            return movieListOutput.movies.map { movie in
                return MovieViewModel(movie: movie,
                                      disposeBag: Assembler.resolve(DisposeBag.self),
                                      useCase: Assembler.resolve(MovieUseCaseProtocol.self),
                                      navigator: Assembler.resolve(MovieNavigatorProtocol.self))
            }
        }
    }
}
