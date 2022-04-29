//
//  MoviePopularNavigator.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import UIKit

protocol MoviePopularNavigatorType {
    func toMovieDetail(_ movieViewModel: MovieViewModel)
}

class MoviePopularNavigator: MoviePopularNavigatorType {
    func toMovieDetail(_ movieViewModel: MovieViewModel) {
        guard let topVC = UIApplication.topStackViewController(), let movie = try? movieViewModel.movie.value() else {
            return
        }
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.setViewModel(MovieDetailViewModel(movie: movie))
        topVC.push(to: movieDetailVC, animated: true)
    }
}
