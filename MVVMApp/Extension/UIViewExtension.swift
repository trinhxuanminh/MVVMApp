//
//  UIViewExtension.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import UIKit

extension UIView {
    @objc func push(to viewController: UIViewController, animated: Bool) {
        guard let topViewController = UIApplication.topStackViewController() else {
            return
        }
        topViewController.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    @objc func pop(animated: Bool) {
        guard let topViewController = UIApplication.topStackViewController() else {
            return
        }
        topViewController.navigationController?.popViewController(animated: animated)
    }
    
    @objc func present(to viewController: UIViewController, animated: Bool) {
        guard let topViewController = UIApplication.topStackViewController() else {
            return
        }
        topViewController.present(viewController, animated: animated, completion: nil)
    }
    
    func nearestAncestor<T>(ofType type: T.Type) -> T? {
        if let me = self as? T { return me }
        return superview?.nearestAncestor(ofType: type)
    }
}
