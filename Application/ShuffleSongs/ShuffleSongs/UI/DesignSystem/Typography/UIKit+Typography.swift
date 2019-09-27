//
//  UIKit+Typography.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// Applies Inter's typography to the Label.
    ///
    /// - Parameters:
    ///   - typography: The Typography type.
    ///   - color: The color of the text.
    func apply(typography: Typography, with color: UIColor) {
        font = typography.font
        textColor = color
    }
    
}

