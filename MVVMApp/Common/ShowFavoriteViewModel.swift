//
//  ShowFavoriteViewModel.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 21/04/2022.
//

import Foundation
import RxSwift
import RxCocoa
import Action

protocol ShowFavoriteViewModelProtocol {
    var disposeBag: DisposeBag { get }
    
    var viewMoreAction: Action<Void, Void>! { get }
}

class ShowFavoriteViewModel: ShowFavoriteViewModelProtocol {
    
    let disposeBag: DisposeBag
    private let navigator: ShowFavoriteNavigatorProtocol
    
    // MARK: - Input
    private(set) var viewMoreAction: Action<Void, Void>!
    // MARK: - Output
    
    
    init(disposeBag: DisposeBag, navigator: ShowFavoriteNavigatorProtocol) {
        self.disposeBag = disposeBag
        self.navigator = navigator
        self.binding()
    }
    
    private func binding() {
        self.viewMoreAction = Action { _ in
            self.navigator.toFavorite()
            return Observable.empty()
        }
    }
}
