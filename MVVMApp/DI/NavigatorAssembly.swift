//
//  NavigatorAssembly.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 12/05/2022.
//

import Foundation
import Swinject

class NavigatorAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MovieNavigatorProtocol.self) { _ in
            return MovieNavigator()
        }
        
        container.register(HomeNavigatorProtocol.self) { resolver in
            return HomeNavigator()
        }
        
        container.register(FavoriteNavigatorProtocol.self) { _ in
            return FavoriteNavigator()
        }
        
        container.register(ShowFavoriteNavigatorProtocol.self) { _ in
            return ShowFavoriteNavigator()
        }
        
        container.register(MoviePopularNavigatorProtocol.self) { _ in
            return MoviePopularNavigator()
        }
        
        container.register(MovieDetailNavigatorProtocol.self) { _ in
            return MovieDetailNavigator()
        }
    }
}
