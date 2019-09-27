//
//  Typography.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

/// Defines the typography for the project
/// OBS: The main purpuse of this is to simplify when creating UIComponents and configuring them
///
/// - largeTitle: for titles, returns a bold SFProDisplay font of size 34
/// - body: for bodies, returns a regular SFProDisplay font of size 17
/// - button: for button titles, returns a semibold SFProDisplay font of size 17
enum Typography {
    
    // MARK: - Types
    
    case largeTitle
    case body
    
    // MARK: - Properties
    
    var font: UIFont {
        switch self {
        case .largeTitle:
            return UIFont.sfPro(ofSize: 34, weight: .bold)
        case .body:
            return UIFont.sfPro(ofSize: 17, weight: .regular)
        }
    }
    
}
