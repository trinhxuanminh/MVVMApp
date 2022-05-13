//
//  DisposeAssembly.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 12/05/2022.
//

import Foundation
import Swinject
import RxSwift

class DisposeAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DisposeBag.self) { _ in
            return DisposeBag()
        }
    }
}
