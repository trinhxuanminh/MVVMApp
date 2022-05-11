//
//  HomeUseCase.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import RxSwift
import SwinjectStoryboard

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
                                      disposeBag: SwinjectStoryboard.defaultContainer.resolve(DisposeBag.self)!,
                                      useCase: SwinjectStoryboard.defaultContainer.resolve(MovieUseCaseProtocol.self)!,
                                      navigator: SwinjectStoryboard.defaultContainer.resolve(MovieNavigatorProtocol.self)!)
            }
        }
    }
}
