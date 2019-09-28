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
    private let maxPermutationAtempts: Int
    private let artistLookupService: ArtistLookupServiceProvider
    private let musicShuffler: MusicShuffling
    
    // MARK: - Initialization
    
    init(
        artistIDs: [String] = ["909253", "1171421960", "358714030" , "1419227", "264111789"],
        maxPermutationAtempts: Int = 10,
        artistLookupService: ArtistLookupServiceProvider,
        musicShuffler: MusicShuffling = DefaultMusicShuffler()
    ) {
        self.artistIDs = artistIDs
        self.maxPermutationAtempts = maxPermutationAtempts
        self.artistLookupService = artistLookupService
        self.musicShuffler = musicShuffler
    }
    
    // MARK: - Public Functions
    
    func execute(completion: @escaping (UseCaseEvent<[MusicInfoItem], FetchShuffledMusicListUseCaseError>) -> Void) {
        completion(.loading())
        artistLookupService.lookupArtistsWithIDs(artistIDs) { [musicShuffler, maxPermutationAtempts] (result) in
            
            do {
                let response = try result.get()
                let items = response
                    .filter { $0.wrapperType == .track && $0.trackName != nil }
                    .map {
                        MusicInfoItem(
                            artworkURL: $0.artworkURL,
                            trackName: $0.trackName,
                            artistName: $0.artistName,
                            primaryGenreName: $0.primaryGenreName
                        )
                    }
                let shuffledItems = musicShuffler.shuffle(items, maxPermutationAtempts: maxPermutationAtempts)
                completion(.data(shuffledItems))
            } catch {
               completion(.serviceError(error))
            }
            
        }
    }
    
}
