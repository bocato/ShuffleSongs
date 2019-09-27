//
//  Metrics.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

/// Defines an abstraction to take care of the metrics used in the project
/// The main idea here is to have descritive names and standardization of the
/// values used through the project, and make it simple/centralized updates
/// when changes to the DesignSystem occours
public struct Metrics {
    
    private init() {}
    
    public struct Margin {
        
        private init() {}
        
        /// 0 points of spacing.
        public static let none: CGFloat = 0
        
        /// 16 points of spacing.
        public static let `default`: CGFloat = 16.0
        
        /// 44 points of spacing.
        public static let top: CGFloat = 44.0
        
        /// 4 points of spacing
        public static let tiny: CGFloat = 2.0
    }
    
}
