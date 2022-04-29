//
//  UIViewControllerExtension.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import UIKit

extension UIViewController {
    @objc func push(to viewController: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    @objc func pop(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    @objc func present(to viewController: UIViewController, animated: Bool) {
        self.present(viewController, animated: animated, completion: nil)
    }
}
