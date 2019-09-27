//
//  UICollectionViewExtension.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

extension UITableView {
    
    /// Dequeues reusable UITableViewCell using class name for indexPath.
    ///
    /// - Parameters:
    ///   - type: UITableViewCell type.
    ///   - indexPath: Cell location in collectionView.
    /// - Returns: UITableViewCell object with associated class name.
    public func dequeueReusableCell<T: UITableViewCell>(ofType type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.className, for: indexPath) as? T else {
            fatalError("Couldn't find UITableViewCell of class \(type.className)")
        }
        return cell
    }
    
}
