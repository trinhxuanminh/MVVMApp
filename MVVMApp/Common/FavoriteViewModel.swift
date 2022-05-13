//
//  FavoriteViewModel.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 21/04/2022.
//

import Foundation
import RxSwift
import RxCocoa
import Differentiator
import Action

protocol FavoriteViewModelProtocol {
    var loadMovieFavoriteAction: Action<Void, [MovieAnimated]>! { get }
    var selectMovieFavoriteAction: Action<IndexPath, Void>! { get }
    var deleteMovieFavoriteAction: Action<MovieViewModelProtocol, Void>! { get }
    
    var sections: BehaviorSubject<[MovieSectionAnimated]> { get }
}

class FavoriteViewModel: FavoriteViewModelProtocol {
    
    private let disposeBag: DisposeBag
    private let useCase: FavoriteUseCaseProtocol
    private let navigator: FavoriteNavigatorProtocol
    
    // MARK: - Input
    private(set) var loadMovieFavoriteAction: Action<Void, [MovieAnimated]>!
    private(set) var selectMovieFavoriteAction: Action<IndexPath, Void>!
    private(set) var deleteMovieFavoriteAction: Action<MovieViewModelProtocol, Void>!
    // MARK: - Output
    
    
    private(set) var sections = BehaviorSubject<[MovieSectionAnimated]>(value: [])
    
    init(disposeBag: DisposeBag, useCase: FavoriteUseCaseProtocol, navigator: FavoriteNavigatorProtocol) {
        self.disposeBag = disposeBag
        self.useCase = useCase
        self.navigator = navigator
        self.binding()
    }
    
    deinit {
        print("deinit viewModel")
    }
    
    private func binding() {
        self.loadMovieFavoriteAction = Action { [weak self] _ in
            guard let self = self else {
                return Observable.never()
            }
            return self.useCase.fetchFavorite()
        }
        
        self.loadMovieFavoriteAction
            .elements
            .subscribe(onNext: { [weak self] (output) in
                guard let self = self else {
                    return
                }
                let section0 = MovieSectionAnimated(items: output)
                self.sections.onNext([section0])
            })
            .disposed(by: disposeBag)
        
        self.loadMovieFavoriteAction
            .errors
            .subscribe(onNext: { error in
                print(error)
            })
            .disposed(by: self.disposeBag)
        
        self.selectMovieFavoriteAction = Action { [weak self] indexPath in
            guard let self = self, let sections = try? self.sections.value() else {
                return Observable.never()
            }
            let section = sections[indexPath.section]
            let listMovieViewModel = section.items as! [MovieViewModel]
            self.navigator.toMovieDetail(listMovieViewModel[indexPath.item])
            return Observable.empty()
        }
        
        self.deleteMovieFavoriteAction = Action { [weak self] movieViewModel in
            guard let self = self, let sections = try? self.sections.value(), let movieDelete = try? movieViewModel.movie.value() else {
                return Observable.never()
            }
            var section0 = sections[0]
            var listMovieAnimated = section0.items
            let indexDelete = listMovieAnimated.firstIndex { movieAnimated in
                guard let movie = movieAnimated.movie else {
                    return false
                }
                return movie.id == movieDelete.id
            }
            guard let indexDelete = indexDelete else {
                return Observable.never()
            }
            listMovieAnimated.remove(at: indexDelete)
            section0.items = listMovieAnimated
            self.sections.onNext([section0])
            return Observable.empty()
        }
    }
}
