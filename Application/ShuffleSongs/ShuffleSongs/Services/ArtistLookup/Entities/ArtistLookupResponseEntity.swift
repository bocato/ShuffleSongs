//
//  ArtistLookupResponseEntity.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

struct ArtistLookupResponseEntity: Codable {
    let resultCount: Int
    let results: [Result]
}
extension ArtistLookupResponseEntity {
    struct Result: Codable {
        let id: Int
        let wrapperType: WrapperType
        let artistType: String?
        let primaryGenreName: String
        let artistName: String
        let country: String?
        let artworkURL, releaseDate: String?
        let artistID, trackTimeMillis: Int?
        let collectionName: String?
        let trackExplicitness: TrackExplicitness?
        let trackCensoredName: String?
        let collectionID: Int?
        let trackName: String?

        enum CodingKeys: String, CodingKey {
            case id, wrapperType, artistType, primaryGenreName, artistName, country
            case artworkURL = "artworkUrl"
            case releaseDate
            case artistID = "artistId"
            case trackTimeMillis, collectionName, trackExplicitness, trackCensoredName
            case collectionID = "collectionId"
            case trackName
        }
    }
}
extension ArtistLookupResponseEntity.Result {
    enum TrackExplicitness: String, Codable {
        case explicit = "explicit"
        case notExplicit = "notExplicit"
    }
}
extension ArtistLookupResponseEntity.Result {
    enum WrapperType: String, Codable {
        case artist = "artist"
        case track = "track"
    }
}
