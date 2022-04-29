//
//  FavoriteNavigator.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import UIKit

protocol FavoriteNavigatorType {
    func toMovieDetail(_ movieViewModel: MovieViewModel)
}

class FavoriteNavigator: FavoriteNavigatorType {
    func toMovieDetail(_ movieViewModel: MovieViewModel) {
        guard let topVC = UIApplication.topStackViewController(), let movie = try? movieViewModel.movie.value() else {
            return
        }
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.setViewModel(MovieDetailViewModel(movie: movie))
        topVC.push(to: movieDetailVC, animated: true)
    }
}
