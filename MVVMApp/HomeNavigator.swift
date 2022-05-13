//
//  HomeNavigator.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import UIKit
import RxSwift
import Swinject

protocol HomeNavigatorProtocol {
    func toMovieDetail(_ movieViewModel: MovieViewModelProtocol)
}

class HomeNavigator: HomeNavigatorProtocol {
    func toMovieDetail(_ movieViewModel: MovieViewModelProtocol) {
        guard let topVC = UIApplication.topStackViewController(), let movie = try? movieViewModel.movie.value() else {
            return
        }
        let movieDetailVC = Assembler.resolve(MovieDetailViewController.self)
        movieDetailVC.setDisposeBag(Assembler.resolve(DisposeBag.self))
        movieDetailVC.setViewModel(MovieDetailViewModel(movie: movie,
                                                        disposeBag: Assembler.resolve(DisposeBag.self),
                                                        useCase: Assembler.resolve(MovieDetailUseCaseProtocol.self),
                                                        navigator: Assembler.resolve(MovieDetailNavigatorProtocol.self)))
        topVC.push(to: movieDetailVC, animated: true)
    }
}
