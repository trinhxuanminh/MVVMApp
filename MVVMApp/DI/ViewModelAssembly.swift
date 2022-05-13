//
//  ViewModelAssembly.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 12/05/2022.
//

import Foundation
import Swinject
import RxSwift

class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomeViewModelProtocol.self) { resolver in
            return HomeViewModel(disposeBag: resolver.resolve(DisposeBag.self)!,
                                 useCase: resolver.resolve(HomeUseCaseProtocol.self)!,
                                 navigator: resolver.resolve(HomeNavigatorProtocol.self)!)
        }
        
        container.register(FavoriteViewModelProtocol.self) { resolver in
            return FavoriteViewModel(disposeBag: resolver.resolve(DisposeBag.self)!,
                                     useCase: resolver.resolve(FavoriteUseCaseProtocol.self)!,
                                     navigator: resolver.resolve(FavoriteNavigatorProtocol.self)!)
        }
        
        container.register(ShowFavoriteViewModelProtocol.self) { resolver in
            return ShowFavoriteViewModel(disposeBag: resolver.resolve(DisposeBag.self)!,
                                         navigator: resolver.resolve(ShowFavoriteNavigatorProtocol.self)!)
        }
        
        container.register(MoviePopularViewModelProtocol.self) { resolver in
            return MoviePopularViewModel(disposeBag: resolver.resolve(DisposeBag.self)!,
                                         useCase: resolver.resolve(MoviePopularUseCaseProtocol.self)!,
                                         navigator: resolver.resolve(MoviePopularNavigatorProtocol.self)!)
        }
    }
}
