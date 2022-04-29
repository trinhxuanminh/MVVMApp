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

class ShowFavoriteViewModel {
    
    let disposeBag = DisposeBag()
    private let navigator = ShowFavoriteNavigator()
    
    // MARK: - Input
    private(set) var viewMoreAction: Action<Void, Void>!
    // MARK: - Output
    
    
    init() {
        self.binding()
    }
    
    private func binding() {
        self.viewMoreAction = Action { _ in
            self.navigator.toFavorite()
            return Observable.empty()
        }
    }
}
