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

class FavoriteViewModel {
    
    private let disposeBag = DisposeBag()
    private let useCase = FavoriteUseCase()
    private let navigator = FavoriteNavigator()
    
    // MARK: - Input
    private(set) var loadMovieFavoriteAction: Action<Void, [MovieViewModel]>!
    private(set) var selectMovieFavoriteAction: Action<IndexPath, Void>!
    private(set) var deleteMovieFavoriteAction: Action<MovieViewModel, Void>!
    // MARK: - Output
    
    
    private(set) var sections = BehaviorSubject<[CustomSectionModel]>(value: [])
    
    init() {
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
                let section0 = CustomSectionModel(items: output)
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
            var listMovieViewModel = section0.items as! [MovieViewModel]
            let indexDelete = listMovieViewModel.firstIndex { movieViewModel in
                guard let movie = try? movieViewModel.movie.value() else {
                    return false
                }
                return movie.id == movieDelete.id
            }
            guard let indexDelete = indexDelete else {
                return Observable.never()
            }
            listMovieViewModel.remove(at: indexDelete)
            section0.items = listMovieViewModel
            self.sections.onNext([section0])
            return Observable.empty()
        }
    }
}
