//
//  AssemblerExtension.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 12/05/2022.
//

import Foundation
import Swinject

extension Assembler {
    static let shared: Assembler = {
        let container = Container()
        let assembler = Assembler([DisposeAssembly(),
                                   RepositoryAssembly(),
                                   ViewAssembly(),
                                   ViewModelAssembly(),
                                   UseCaseAssembly(),
                                   NavigatorAssembly()
                                  ], container: container)
        return assembler
    }()
    
    class func resolve<T>(_ type: T.Type) -> T {
        self.shared.resolver.resolve(T.self)!
    }
}
