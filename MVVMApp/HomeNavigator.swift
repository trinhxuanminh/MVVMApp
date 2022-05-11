//
//  HomeNavigator.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import UIKit
import SwinjectStoryboard
import RxSwift

protocol HomeNavigatorProtocol {
    func toMovieDetail(_ movieViewModel: MovieViewModelProtocol)
}

class HomeNavigator: HomeNavigatorProtocol {
    func toMovieDetail(_ movieViewModel: MovieViewModelProtocol) {
        guard let topVC = UIApplication.topStackViewController(), let movie = try? movieViewModel.movie.value() else {
            return
        }
        let movieDetailVC = SwinjectStoryboard.defaultContainer.resolve(MovieDetailViewController.self)!
        movieDetailVC.setDisposeBag(SwinjectStoryboard.defaultContainer.resolve(DisposeBag.self)!)
        movieDetailVC.setViewModel(MovieDetailViewModel(movie: movie,
                                                        disposeBag: SwinjectStoryboard.defaultContainer.resolve(DisposeBag.self)!,
                                                        useCase: SwinjectStoryboard.defaultContainer.resolve(MovieDetailUseCaseProtocol.self)!,
                                                        navigator: SwinjectStoryboard.defaultContainer.resolve(MovieDetailNavigatorProtocol.self)!))
        topVC.push(to: movieDetailVC, animated: true)
    }
}
