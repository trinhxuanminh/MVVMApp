//
//  HomeViewModel.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 19/04/2022.
//

import Foundation
import RxSwift
import RxCocoa
import Differentiator
import Action

protocol HomeViewModelProtocol {
    var loadMovieNowPlayingAction: Action<Void, [MovieViewModelProtocol]>! { get }
    var selectMovieNowPlayingAction: Action<IndexPath, Void>! { get }
    
    var sections: BehaviorSubject<[CustomSectionModel]> { get }
}

class HomeViewModel: HomeViewModelProtocol {
    
    private let disposeBag: DisposeBag
    private let useCase: HomeUseCaseProtocol
    private let navigator: HomeNavigatorProtocol
    
    // MARK: - Input
    private(set) var loadMovieNowPlayingAction: Action<Void, [MovieViewModelProtocol]>!
    private(set) var selectMovieNowPlayingAction: Action<IndexPath, Void>!
    // MARK: - Output
    
    
    private(set) var sections = BehaviorSubject<[CustomSectionModel]>(value: [])
    
    init(disposeBag: DisposeBag, useCase: HomeUseCaseProtocol, navigator: HomeNavigatorProtocol) {
        self.disposeBag = disposeBag
        self.useCase = useCase
        self.navigator = navigator
        self.binding()
    }
    
    private func binding() {
        self.loadMovieNowPlayingAction = Action { [weak self] _ in
            guard let self = self else {
                return Observable.never()
            }
            return self.useCase.loadMovieNowPlaying()
        }
        
        self.loadMovieNowPlayingAction
            .elements
            .subscribe(onNext: { [weak self] (output) in
                guard let self = self else {
                    return
                }
                let section0 = CustomSectionModel(items: [Any?](repeating: nil, count: 3))
                let section1 = CustomSectionModel(items: output)
                self.sections.onNext([section0, section1])
            })
            .disposed(by: disposeBag)
        
        self.loadMovieNowPlayingAction
            .errors
            .subscribe(onNext: { error in
                print(error)
            })
            .disposed(by: self.disposeBag)
        
        self.selectMovieNowPlayingAction = Action { [weak self] indexPath in
            guard let self = self, let sections = try? self.sections.value() else {
                return Observable.never()
            }
            if indexPath.section == 0 {
                return Observable.never()
            }
            let section = sections[indexPath.section]
            let listMovieViewModel = section.items as! [MovieViewModel]
            self.navigator.toMovieDetail(listMovieViewModel[indexPath.item])
            return Observable.empty()
        }
    }
}
