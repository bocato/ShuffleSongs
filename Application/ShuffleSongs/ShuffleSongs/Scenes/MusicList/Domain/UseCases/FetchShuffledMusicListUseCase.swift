//
//  FetchShuffledMusicListUseCase.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

/// Defines an error for this domain
enum FetchShuffledMusicListUseCaseError: Error {}

// Defines a command to request the Quiz data
protocol FetchShuffledMusicListUseCaseProvider {
    
    /// Fetches the data for the QuizView
    ///
    /// - Parameter completion: async response for the MusicInfoItems suffled array
    func execute(completion: @escaping (UseCaseEvent<[MusicInfoItem], FetchShuffledMusicListUseCaseError>) -> Void)
}

final class FetchShuffledMusicListUseCase: FetchShuffledMusicListUseCaseProvider {
    
    // MARK: - Dependencies
    
    private let artistIDs: [String]
    private let artistLookupService: ArtistLookupServiceProvider
    private let arrayShuffler: ArrayShuffling
    
    // MARK: - Initialization
    
    init(
        artistIDs: [String] = ["909253", "1171421960", "358714030" , "1419227", "264111789"],
        artistLookupService: ArtistLookupServiceProvider,
        arrayShuffler: ArrayShuffling = DefaultArrayShuffler()
    ) {
        self.artistIDs = artistIDs
        self.artistLookupService = artistLookupService
        self.arrayShuffler = arrayShuffler
    }
    
    // MARK: - Public Functions
    
    func execute(completion: @escaping (UseCaseEvent<[MusicInfoItem], FetchShuffledMusicListUseCaseError>) -> Void) {
        completion(.loading())
        artistLookupService.lookupArtistsWithIDs(artistIDs) { [arrayShuffler] (result) in
            
            do {
                let response = try result.get()
                let items = response
                    .filter { $0.wrapperType == .track }
                    .map {
                        MusicInfoItem(
                            artworkURL: $0.artworkURL,
                            trackName: $0.trackName,
                            artistName: $0.artistName,
                            primaryGenreName: $0.primaryGenreName
                        )
                    }
                let shuffledItems = arrayShuffler.shuffle(items)
                completion(.data(shuffledItems))
            } catch {
               completion(.serviceError(error))
            }
            
        }
    }
    
}
