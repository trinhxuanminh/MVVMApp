//
//  MoviePopularViewModel.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 20/04/2022.
//

import Foundation
import RxSwift
import RxCocoa
import Differentiator
import Action
import Alamofire

protocol MoviePopularViewModelProtocol {
    var disposeBag: DisposeBag { get }
    
    var loadMoviePopularAction: Action<Void, [MovieViewModelProtocol]>! { get }
    var selectMoviePopularAction: Action<IndexPath, Void>! { get }
    
    var sections: BehaviorSubject<[CustomSectionModel]> { get }
}

class MoviePopularViewModel: MoviePopularViewModelProtocol {
    
    let disposeBag: DisposeBag
    private let useCase: MoviePopularUseCaseProtocol
    private let navigator: MoviePopularNavigatorProtocol
    
    // MARK: - Input
    private(set) var loadMoviePopularAction: Action<Void, [MovieViewModelProtocol]>!
    private(set) var selectMoviePopularAction: Action<IndexPath, Void>!
    // MARK: - Output
    
    
    private(set) var sections = BehaviorSubject<[CustomSectionModel]>(value: [])
    
    init(disposeBag: DisposeBag, useCase: MoviePopularUseCaseProtocol, navigator: MoviePopularNavigatorProtocol) {
        self.disposeBag = disposeBag
        self.useCase = useCase
        self.navigator = navigator
        self.binding()
    }
    
    private func binding() {
        self.loadMoviePopularAction = Action { [weak self] _ in
            guard let self = self else {
                return Observable.never()
            }
            return self.useCase.loadMoviePopular()
        }
        
        self.loadMoviePopularAction
            .elements
            .subscribe(onNext: { [weak self] (output) in
                guard let self = self, let sections = try? self.sections.value() else {
                    return
                }
                
                var section0: CustomSectionModel!
                if sections.isEmpty {
                    section0 = CustomSectionModel(items: output)
                } else {
                    section0 = sections[0]
                    let listMovieViewModel = section0.items as! [MovieViewModel]
                    section0.items = listMovieViewModel + output
                }
                self.sections.onNext([section0])
            })
            .disposed(by: self.disposeBag)
        
        self.loadMoviePopularAction
            .errors
            .subscribe(onNext: { error in
                print(error)
            })
            .disposed(by: self.disposeBag)
        
        self.selectMoviePopularAction = Action { [weak self] indexPath in
            guard let self = self, let sections = try? self.sections.value() else {
                return Observable.never()
            }
            let section = sections[indexPath.section]
            let listMovieViewModel = section.items as! [MovieViewModel]
            self.navigator.toMovieDetail(listMovieViewModel[indexPath.item])
            return Observable.empty()
        }
    }
}
