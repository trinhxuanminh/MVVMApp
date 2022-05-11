//
//  Swinject.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 11/05/2022.
//

import Foundation
import SwinjectStoryboard
import RxSwift

extension SwinjectStoryboard {
    @objc class func setup() {
        self.defaultContainer.register(DisposeBag.self) { _ in
            return DisposeBag()
        }
        
        self.defaultContainer.register(MovieRepositoryProtocol.self) { _ in
            return MovieRepository()
        }
        
        self.defaultContainer.register(MovieUseCaseProtocol.self) { resolver in
            return MovieUseCase(movieRepository: resolver.resolve(MovieRepositoryProtocol.self)!)
        }
        
        self.defaultContainer.register(MovieNavigatorProtocol.self) { _ in
            return MovieNavigator()
        }
        
        self.defaultContainer.register(HomeUseCaseProtocol.self) { resolver in
            return HomeUseCase(movieRepository: resolver.resolve(MovieRepositoryProtocol.self)!)
        }
        
        self.defaultContainer.register(HomeNavigatorProtocol.self) { resolver in
            return HomeNavigator()
        }
        
        self.defaultContainer.register(HomeViewModelProtocol.self) { resolver in
            return HomeViewModel(disposeBag: resolver.resolve(DisposeBag.self)!,
                                 useCase: resolver.resolve(HomeUseCaseProtocol.self)!,
                                 navigator: resolver.resolve(HomeNavigatorProtocol.self)!)
        }
        
        self.defaultContainer.register(HomeViewController.self) { resolver in
            let viewController = HomeViewController()
            viewController.setDisposeBag(resolver.resolve(DisposeBag.self)!)
            viewController.setViewModel(resolver.resolve(HomeViewModelProtocol.self)!)
            return viewController
        }
        
        self.defaultContainer.register(FavoriteUseCaseProtocol.self) { resolver in
            return FavoriteUseCase(movieRepository: resolver.resolve(MovieRepositoryProtocol.self)!)
        }
        
        self.defaultContainer.register(FavoriteNavigatorProtocol.self) { _ in
            return FavoriteNavigator()
        }
        
        self.defaultContainer.register(FavoriteViewModelProtocol.self) { resolver in
            return FavoriteViewModel(disposeBag: resolver.resolve(DisposeBag.self)!,
                                     useCase: resolver.resolve(FavoriteUseCaseProtocol.self)!,
                                     navigator: resolver.resolve(FavoriteNavigatorProtocol.self)!)
        }
        
        self.defaultContainer.register(FavoriteViewController.self) { resolver in
            let viewController = FavoriteViewController()
            viewController.setDisposeBag(resolver.resolve(DisposeBag.self)!)
            viewController.setViewModel(resolver.resolve(FavoriteViewModelProtocol.self)!)
            return viewController
        }
        
        self.defaultContainer.register(MovieDetailViewController.self) { _ in
            return MovieDetailViewController()
        }
        
        self.defaultContainer.register(ShowFavoriteNavigatorProtocol.self) { _ in
            return ShowFavoriteNavigator()
        }
        
        self.defaultContainer.register(ShowFavoriteViewModelProtocol.self) { resolver in
            return ShowFavoriteViewModel(disposeBag: resolver.resolve(DisposeBag.self)!,
                                         navigator: resolver.resolve(ShowFavoriteNavigatorProtocol.self)!)
        }
        
        self.defaultContainer.register(MoviePopularUseCaseProtocol.self) { resolver in
            return MoviePopularUseCase(movieRepository: resolver.resolve(MovieRepositoryProtocol.self)!)
        }
        
        self.defaultContainer.register(MoviePopularNavigatorProtocol.self) { _ in
            return MoviePopularNavigator()
        }
        
        self.defaultContainer.register(MoviePopularViewModelProtocol.self) { resolver in
            return MoviePopularViewModel(disposeBag: resolver.resolve(DisposeBag.self)!,
                                         useCase: resolver.resolve(MoviePopularUseCaseProtocol.self)!,
                                         navigator: resolver.resolve(MoviePopularNavigatorProtocol.self)!)
        }
        
        self.defaultContainer.register(MovieDetailUseCaseProtocol.self) { resolver in
            return MovieDetailUseCase(movieRepository: resolver.resolve(MovieRepositoryProtocol.self)!)
        }
        
        self.defaultContainer.register(MovieDetailNavigatorProtocol.self) { _ in
            return MovieDetailNavigator()
        }
    }
}
