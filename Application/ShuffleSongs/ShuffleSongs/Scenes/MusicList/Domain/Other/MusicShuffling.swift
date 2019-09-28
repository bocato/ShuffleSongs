//
//  MusicShuffling.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation



protocol MusicShuffling {
    
    /// Shuffles an array of type T, returning a suffled version of the provided array
    /// - Parameter array: some array
    func shuffle(_ array: [MusicInfoItem]) -> [MusicInfoItem]
}

final class DefaultMusicShuffler: MusicShuffling {
    
    func shuffle(_ array: Array<MusicInfoItem>) -> Array<MusicInfoItem> {
        
        // Since the backend sends the elements clustered by artistName
        // we first need to shuffle them a little
        let shuffled = knuthShuffle(array)
        
        // After that, we shuffle it again, minimizing the neighbors
        let minimizeNeighborsArray = minimizeNeighbors(in: shuffled)
        
        // Then we can return
        return minimizeNeighborsArray
    }
    
    /// This is `The Fisher-Yates / Knuth shuffle`
    /// More information about the implementation used here can be found at:
    /// https://github.com/raywenderlich/swift-algorithm-club/tree/master/Shuffle
    private func knuthShuffle(_ array: [MusicInfoItem]) -> [MusicInfoItem] {
        var shuffled = array
        let lenght = shuffled.count - 1
        for i in stride(from: lenght, through: 1, by: -1) {
            let j = Int.random(in: 0...i)
            if i != j {
                shuffled.swapAt(i, j)
            }
        }
        return shuffled
    }
    
    /// This function tries to minimize de adjacent neighbors that have the same artistName
    private func minimizeNeighbors(in array: [MusicInfoItem]) -> [MusicInfoItem] {
        
        if array.count < 2 {
            return array
        }
        
        var output = [MusicInfoItem?]()
        var stack = array
        
        var lastItem: MusicInfoItem?
        var nextItem: MusicInfoItem?
        
        while stack.count > 0  {
            
            // If we are back to the first item, reverse the array and
            // start the process again until there is no more items left
            if stack.first?.artistName == lastItem?.artistName {
                stack.reverse()
            }
            
            // Add the item on the top of the stack to the output
            // and then, remove it from the possible items to check
            // after that, save it to compare with the next item
            nextItem = stack.first
            stack.remove(at: 0)
            output.append(nextItem)
            lastItem = nextItem
            
        }
        
        return output.compactMap { $0 }
    }
    
}
