//
//  ArtistLookupResponseEntityResult+Fixtures.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 28/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation
@testable import ShuffleSongs

extension ArtistLookupResponseEntity.Result {
    
    static func fixture(
        id: Int = 0,
        wrapperType: ArtistLookupResponseEntity.Result.WrapperType = .track,
        artistType: String? = nil,
        primaryGenreName: String = "primaryGenreName",
        artistName: String = "artistName",
        country: String? = nil,
        artworkURL: String? = nil,
        releaseDate: String? = nil,
        artistID: Int? = nil,
        trackTimeMillis: Int? = nil,
        collectionName: String? = nil,
        trackExplicitness: ArtistLookupResponseEntity.Result.TrackExplicitness? = nil,
        trackCensoredName: String? = nil,
        collectionID: Int? = nil,
        trackName: String? = nil
    ) -> ArtistLookupResponseEntity.Result {
        return ArtistLookupResponseEntity.Result(
            id: id,
            wrapperType: wrapperType,
            artistType: artistType,
            primaryGenreName: primaryGenreName,
            artistName: artistName,
            country: country,
            artworkURL: artworkURL,
            releaseDate: releaseDate,
            artistID: artistID,
            trackTimeMillis: trackTimeMillis,
            collectionName: collectionName,
            trackExplicitness: trackExplicitness,
            trackCensoredName: trackCensoredName,
            collectionID: collectionID,
            trackName: trackName
        )
    }
}
