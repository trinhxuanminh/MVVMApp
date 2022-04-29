//
//  MovieDetailNavigator.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import UIKit

protocol MovieDetailNavigatorType {
    func back()
}

class MovieDetailNavigator: MovieDetailNavigatorType {
    func back() {
        guard let topVC = UIApplication.topStackViewController() else {
            return
        }
        topVC.pop(animated: true)
    }
}
