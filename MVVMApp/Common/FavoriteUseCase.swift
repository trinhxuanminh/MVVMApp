//
//  FavoriteUseCase.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import RxSwift
import SwinjectStoryboard

protocol FavoriteUseCaseProtocol {
    func fetchFavorite() -> Observable<[MovieViewModelProtocol]>
}

class FavoriteUseCase: FavoriteUseCaseProtocol {
    
    private let movieRepository: MovieRepositoryProtocol
    
    init(movieRepository: MovieRepositoryProtocol) {
        self.movieRepository = movieRepository
    }
    
    func fetchFavorite() -> Observable<[MovieViewModelProtocol]> {
        return self.movieRepository.fetchFavorite().map { movies in
            return movies.reversed().map { movie in
                return MovieViewModel(movie: movie,
                                      disposeBag: SwinjectStoryboard.defaultContainer.resolve(DisposeBag.self)!,
                                      useCase: SwinjectStoryboard.defaultContainer.resolve(MovieUseCaseProtocol.self)!,
                                      navigator: SwinjectStoryboard.defaultContainer.resolve(MovieNavigatorProtocol.self)!)
            }
        }
    }
}
