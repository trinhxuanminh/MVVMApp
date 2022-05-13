//
//  RepositoryAssembly.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 12/05/2022.
//

import Foundation
import Swinject

class RepositoryAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MovieRepositoryProtocol.self) { _ in
            return MovieRepository()
        }
    }
}
