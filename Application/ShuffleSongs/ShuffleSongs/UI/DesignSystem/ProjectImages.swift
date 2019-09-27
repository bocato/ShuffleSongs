//
//  ProjectImages.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Returns the image corresponding to `shuffle` asset
    class var shuffle: UIImage {
        return UIImage(named: "shuffle") ?? UIImage()
    }
    
    /// Returns the image corresponding to `artworkPlaceholder` asset
    class var logo: UIImage {
        return UIImage(named: "logo") ?? UIImage()
    }
    
}
