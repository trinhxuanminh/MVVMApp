//
//  AppIcon.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 19/04/2022.
//

import Foundation
import UIKit

class AppIcon {
    enum Icon {
        case splash
        case defaultIcon
        case defaultIcon2
        case star
        case illustration
        case deselectFavorite
        case selectFavorite
        case deleteFavorite
        case back
        case date
    }
    
    static func image(icon: Icon) -> UIImage {
        if let image = UIImage(named: "\(icon)") {
            return image
        } else if let imageSystem = UIImage(systemName: "\(icon)") {
            return imageSystem
        }
        return image(icon: Icon.defaultIcon)
    }
}
