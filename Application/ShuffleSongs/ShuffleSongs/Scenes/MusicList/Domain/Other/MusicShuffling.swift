//
//  MusicShuffling.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation



protocol MusicShuffling {
    
    /// Shuffles an array of type MusicInfoItem, returning a suffled version of the provided array
    /// - Parameter array: some array
    func shuffle(_ array: [MusicInfoItem]) -> [MusicInfoItem]
}

final class DefaultMusicShuffler: MusicShuffling {
    
    func shuffle(_ array: [MusicInfoItem]) -> [MusicInfoItem] {

        // If the array has 2 items, there is no point in shuffling it
        if array.count <= 2 {
            return array
        }

        // Since the backend sends the elements clustered by artistName
        // we first need to shuffle them a little
        let shuffled = knuthShuffle(array)

        // Now we try to find a permutation, for some time (max size of the array),
        // if we cant find one in the maxAttempts defined, we return the shuffle result
        let permutationResult = findPermutation(shuffled, maxAtempts: array.count) ?? shuffled
        
        return permutationResult
    }

    /// This is an adaptation from the Backtracking algorithm proposed by @LuccaAngeletti on:
    /// https://stackoverflow.com/questions/39170398/is-there-a-way-to-shuffle-an-array-so-that-no-two-consecutive-values-are-the-sam
    func findPermutation(_ unusedElments: [MusicInfoItem], sequence: [MusicInfoItem] = [], maxAtempts: Int) -> [MusicInfoItem]? {
        guard !Array(zip(sequence.dropFirst(), sequence)).contains(where: { $0.0.artistName == $0.1.artistName }) else { return nil }
        guard !unusedElments.isEmpty else { return sequence }

        for i in 0..<unusedElments.count {
            var unusedElms = unusedElments
            let newElm = unusedElms.remove(at: i)
            let newSequence = sequence + [newElm]
            if let solution = findPermutation(unusedElms, sequence: newSequence, maxAtempts: maxAtempts - 1) {
                return solution
            } else if maxAtempts <= 0 {
                return nil
            }
        }
        
        return nil
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
    
}
