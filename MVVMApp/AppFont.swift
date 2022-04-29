//
//  AppFont.swift
//  BoxTrailer
//
//  Created by Trịnh Xuân Minh on 08/04/2022.
//

import Foundation
import UIKit

class AppFont {
    enum FontName: String {
        case openSans_Bold = "OpenSans-Bold"
        case openSans_Regular = "OpenSans-Regular"
        case openSans_SemiBold = "OpenSans-SemiBold"
    }
    
    class func getFont(fontName: FontName, size: CGFloat) -> UIFont {
        return UIFont(name: fontName.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
