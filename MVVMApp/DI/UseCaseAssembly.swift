//
//  UseCaseAssembly.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 12/05/2022.
//

import Foundation
import Swinject

class UseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MovieUseCaseProtocol.self) { resolver in
            return MovieUseCase(movieRepository: resolver.resolve(MovieRepositoryProtocol.self)!)
        }
        
        container.register(HomeUseCaseProtocol.self) { resolver in
            return HomeUseCase(movieRepository: resolver.resolve(MovieRepositoryProtocol.self)!)
        }
        
        container.register(FavoriteUseCaseProtocol.self) { resolver in
            return FavoriteUseCase(movieRepository: resolver.resolve(MovieRepositoryProtocol.self)!)
        }
        
        container.register(MoviePopularUseCaseProtocol.self) { resolver in
            return MoviePopularUseCase(movieRepository: resolver.resolve(MovieRepositoryProtocol.self)!)
        }
        
        container.register(MovieDetailUseCaseProtocol.self) { resolver in
            return MovieDetailUseCase(movieRepository: resolver.resolve(MovieRepositoryProtocol.self)!)
        }
    }
}
