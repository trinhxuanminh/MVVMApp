//
//  ShowFavoriteNavigator.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import UIKit
import SwinjectStoryboard

protocol ShowFavoriteNavigatorProtocol {
    func toFavorite()
}

class ShowFavoriteNavigator: ShowFavoriteNavigatorProtocol {
    func toFavorite() {
        guard let topVC = UIApplication.topStackViewController() else {
            return
        }
        topVC.push(to: SwinjectStoryboard.defaultContainer.resolve(FavoriteViewController.self)!, animated: true)
    }
}
