//
//  ArrayShuffler.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation



protocol MusicShuffling {
    
    /// Shuffles an array of type T, returning a suffled version of the provided array
    /// - Parameter array: some array
    func shuffle(_ array: Array<MusicInfoItem>) -> Array<MusicInfoItem>
}

/// This class implements the `The Fisher-Yates / Knuth shuffle`.
/// More information about the implementation used here can be found at:
/// https://github.com/raywenderlich/swift-algorithm-club/tree/master/Shuffle
final class DefaultMusicShuffler: MusicShuffling {
    
    func shuffle(_ array: Array<MusicInfoItem>) -> Array<MusicInfoItem> {
        
        var shuffled = array.shuffled()
        
        for i in stride(from: shuffled.count - 1, through: 1, by: -1) {
            let j = Int.random(in: 0...i)
            let shouldSwap = i != j && shuffled[i] != shuffled[j]
            if shouldSwap {
                shuffled.swapAt(i, j)
            }
        }
        
        return shuffled
    }
    
    
}
