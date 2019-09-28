//
//  MusicShufflingTests.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 28/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import ShuffleSongs
import Networking

final class MusicShufflingTests: XCTestCase {
    
    func test_suffleTwoElements_shouldReturnTheSameElements() {
        // Given
        let musicItems: [MusicInfoItem] = [
            MusicInfoItem(artworkURL: nil, trackName: "trackName 1", artistName: "artistName 1", primaryGenreName: "primaryGenreName 1"),
            MusicInfoItem(artworkURL: nil, trackName: "trackName 2", artistName: "artistName 2", primaryGenreName: "primaryGenreName 2")
        ]
        let sut = DefaultMusicShuffler()
        
        // When
        let shuffled = sut.shuffle(musicItems)
        
        // Then
        XCTAssertEqual(shuffled, musicItems, "Expected the arrays to be the same.")
    }
    
    func test_whenSufflingAnArrayWithEvenNumberOfArtists_itShouldReturnAnArrayAvoidingNeighbors() {
        // Given
        let musicItems: [MusicInfoItem] = [
            MusicInfoItem(artworkURL: nil, trackName: "trackName 1", artistName: "1", primaryGenreName: "primaryGenreName 1"),
            MusicInfoItem(artworkURL: nil, trackName: "trackName 2", artistName: "1", primaryGenreName: "primaryGenreName 1"),
            MusicInfoItem(artworkURL: nil, trackName: "trackName 3", artistName: "2", primaryGenreName: "primaryGenreName 1"),
            MusicInfoItem(artworkURL: nil, trackName: "trackName 4", artistName: "2", primaryGenreName: "primaryGenreName 1")
        ]
        let sut = DefaultMusicShuffler()
        let expectArtistNamesOrder = [["1", "2", "1", "2"], ["2", "1", "2", "1"]]
        
        // When
        let shuffled = sut.shuffle(musicItems)
        
        // Then
        let shuffledArtistNamesOrder = shuffled.map { $0.artistName }
        let originalArtistNamesOrder = musicItems.map { $0.artistName }
        XCTAssertNotEqual(shuffledArtistNamesOrder, originalArtistNamesOrder, "Expected the arrays to be the different.")
        XCTAssertTrue(expectArtistNamesOrder.contains(shuffledArtistNamesOrder), "Expected some of those possibilities -> \(expectArtistNamesOrder), but got -> \(shuffledArtistNamesOrder).")
    }
    
    func test_whenSufflingAnArrayWithOddNumberOfArtists_itShouldReturnAShuffledArrayPossiblyWithNeighbors() {
        // Given
        let musicItems: [MusicInfoItem] = [
            MusicInfoItem(artworkURL: nil, trackName: "trackName 1", artistName: "1", primaryGenreName: "primaryGenreName 1"),
            MusicInfoItem(artworkURL: nil, trackName: "trackName 2", artistName: "1", primaryGenreName: "primaryGenreName 1"),
            MusicInfoItem(artworkURL: nil, trackName: "trackName 3", artistName: "2", primaryGenreName: "primaryGenreName 1")
        ]
        let sut = DefaultMusicShuffler()
        
        // When
        let shuffled = sut.shuffle(musicItems)
        
        // Then
        let shuffledArtistNamesOrder = shuffled.map { $0.artistName }
        let originalArtistNamesOrder = musicItems.map { $0.artistName }
        XCTAssertNotEqual(shuffledArtistNamesOrder, originalArtistNamesOrder, "Expected the arrays to be the different.")
    }
    
}

// MARK: - Testing Helpers
extension MusicInfoItem: Equatable {
    public static func == (lhs: MusicInfoItem, rhs: MusicInfoItem) -> Bool {
        return lhs.artworkURL == rhs.artworkURL
            && lhs.trackName == rhs.trackName
            && lhs.artistName == rhs.artistName
            && lhs.primaryGenreName == rhs.primaryGenreName
    }
}
