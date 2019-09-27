//
//  ArrayShuffler.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation



protocol ArrayShuffling {
    
    /// Shuffles an array of type T, returning a suffled version of the provided array
    /// - Parameter array: some array
    func shuffle<T>(_ array: Array<T>) -> Array<T>
}

/// This class implements the `The Fisher-Yates / Knuth shuffle`.
/// More information about the implementation used here can be found at:
/// https://github.com/raywenderlich/swift-algorithm-club/tree/master/Shuffle
final class DefaultArrayShuffler: ArrayShuffling {
    
    func shuffle<T>(_ array: Array<T>) -> Array<T> {
        
        var shuffled = array
        
        for i in stride(from: shuffled.count - 1, through: 1, by: -1) {
          let j = Int.random(in: 0...i)
          if i != j {
            shuffled.swapAt(i, j)
          }
        }
        
        return shuffled
    }
    
}
