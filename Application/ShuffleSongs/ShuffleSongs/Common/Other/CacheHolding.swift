//
//  CacheHolding.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation
import Caching

protocol CacheHolding {
    var cache: CacheServiceProvider? { get set }
    func resetCaches()
}
extension CacheHolding {
    func resetCaches() {
        cache?.clear(nil)
    }
}
