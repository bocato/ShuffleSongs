//
//  MusicListViewDataConverterTests.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 28/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import ShuffleSongs
import Networking

final class MusicListViewDataConverterTests: XCTestCase {
    
    func test_convert_whenTrackNamesAreValid_convertShouldReturnExpectedViewDataItems() {
        // Given
        let musicItems: [MusicInfoItem] = [
            MusicInfoItem(artworkURL: nil, trackName: "trackName", artistName: "artistName", primaryGenreName: "primaryGenreName")
        ]
        let expectedConvertedItem = MusicListItemViewData(
            imageURL: nil,
            title: "trackName",
            subtitle: "artistName (primaryGenreName)"
        )
        let sut = MusicListViewDataConverter()
        
        // When
        let convertedItems = sut.convert(musicItems)
        
        // Then
        XCTAssertEqual(convertedItems.first?.imageURL, expectedConvertedItem.imageURL, "Expected \(expectedConvertedItem.imageURL ?? "nil"), but got \(convertedItems.first?.imageURL ?? "nil").")
        XCTAssertEqual(convertedItems.first?.title, expectedConvertedItem.title, "Expected \(expectedConvertedItem.title), but got \(convertedItems.first?.title ?? "nil").")
        XCTAssertEqual(convertedItems.first?.subtitle, expectedConvertedItem.subtitle, "Expected \(expectedConvertedItem.subtitle), but got \(convertedItems.first?.subtitle ?? "nil").")
    }
    
    func test_convert_whenTrackNamesAreInvalid_convertShouldReturnExpectedViewDataItems() {
        // Given
        let musicItems: [MusicInfoItem] = [
            MusicInfoItem(artworkURL: nil, trackName: nil, artistName: "artistName", primaryGenreName: "primaryGenreName")
        ]
        let expectedConvertedItem = MusicListItemViewData(
            imageURL: nil,
            title: "",
            subtitle: "artistName (primaryGenreName)"
        )
        let sut = MusicListViewDataConverter()
        
        // When
        let convertedItems = sut.convert(musicItems)
        
        // Then
        XCTAssertEqual(convertedItems.first?.imageURL, expectedConvertedItem.imageURL, "Expected \(expectedConvertedItem.imageURL ?? "nil"), but got \(convertedItems.first?.imageURL ?? "nil").")
        XCTAssertEqual(convertedItems.first?.title, expectedConvertedItem.title, "Expected \(expectedConvertedItem.title), but got \(convertedItems.first?.title ?? "nil").")
        XCTAssertEqual(convertedItems.first?.subtitle, expectedConvertedItem.subtitle, "Expected \(expectedConvertedItem.subtitle), but got \(convertedItems.first?.subtitle ?? "nil").")
    }
    
}
