//
//  UICollectionViewCellExtension.swift
//  MovieIOS7
//
//  Created by Trịnh Xuân Minh on 13/03/2022.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    func getIndexPath() -> IndexPath? {
        guard let collectionView = self.nearestAncestor(ofType: UICollectionView.self) else {
            return nil
        }
        return collectionView.indexPath(for: self)
    }
}
