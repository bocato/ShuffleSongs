//
//  MusicListConfigurator.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

protocol MusicListConfigurator {
    /// Creates a new instance of MusicListViewController with all it's dependecies
    func makeMusicListViewController() -> MusicListViewController
}
