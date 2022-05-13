//
//  ViewAssembly.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 12/05/2022.
//

import Foundation
import Swinject
import RxSwift

class ViewAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomeViewController.self) { resolver in
            let viewController = HomeViewController()
            viewController.setDisposeBag(resolver.resolve(DisposeBag.self)!)
            viewController.setViewModel(resolver.resolve(HomeViewModelProtocol.self)!)
            return viewController
        }
        
        container.register(FavoriteViewController.self) { resolver in
            let viewController = FavoriteViewController()
            viewController.setDisposeBag(resolver.resolve(DisposeBag.self)!)
            viewController.setViewModel(resolver.resolve(FavoriteViewModelProtocol.self)!)
            return viewController
        }
        
        container.register(MovieDetailViewController.self) { _ in
            return MovieDetailViewController()
        }
    }
}
