//
//  NSObjectExtension.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

extension NSObject {
    
    /// Returns the classes name 
    public static var className: String {
        return String(describing: self)
    }
    
}
