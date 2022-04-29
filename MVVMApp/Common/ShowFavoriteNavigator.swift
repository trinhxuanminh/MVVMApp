//
//  ShowFavoriteNavigator.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import UIKit

protocol ShowFavoriteNavigatorType {
    func toFavorite()
}

class ShowFavoriteNavigator: ShowFavoriteNavigatorType {
    func toFavorite() {
        guard let topVC = UIApplication.topStackViewController() else {
            return
        }
        topVC.push(to: FavoriteViewController(), animated: true)
    }
}
