//
//  FetchShuffledMusicListUseCaseTests.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 28/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import ShuffleSongs
import Networking

final class FetchShuffledMusicListUseCaseTests: XCTestCase {
    
    func test_whenInitIsCalledWithoutPassingArtistIDsParameter_theArtistLookupServiceShouldReceiveDefaultArtistIDsWhenCalled() {
        // Given
        let expectedArtistIDs = ["909253", "1171421960", "358714030" , "1419227", "264111789"]
        let artistLookupServiceProviderSpy = ArtistLookupServiceProviderSpy()
        let sut = FetchShuffledMusicListUseCase(artistLookupService: artistLookupServiceProviderSpy)
        
        // When
        sut.execute { _ in }
        
        // Then
        XCTAssertTrue(artistLookupServiceProviderSpy.lookupArtistsWithIDsCalled, "`lookupArtistsWithIDs` should have been called.")
        let idsPassed = artistLookupServiceProviderSpy.idsPassed
        XCTAssertEqual(expectedArtistIDs, idsPassed, "Expected \(expectedArtistIDs), but got \(idsPassed ?? [])")
    }
    
    func test_whenArtistLookupServiceFails_theUseCaseShouldReturnTheExpectedStates() {
        // Given
        let artistLookupServiceProviderStub = ArtistLookupServiceProviderStub(
            resultToReturn: .failure(.networking(.noData))
        )
        let sut = FetchShuffledMusicListUseCase(artistLookupService: artistLookupServiceProviderStub)
        let expectedEventsCount = 2
        var eventsCollected = [UseCaseEvent<[MusicInfoItem], FetchShuffledMusicListUseCaseError>]()
        
        // When
        let executeExpectation = expectation(description: "executeExpectation")
        sut.execute { event in
            eventsCollected.append(event)
            if eventsCollected.count == expectedEventsCount {
                executeExpectation.fulfill()
            }
        }
        wait(for: [executeExpectation], timeout: 1.0)
        
        // Then
        let statuses = eventsCollected.map { $0.status }
        guard case .loading = statuses[0] else {
            XCTFail("Expected .loading, but got \(statuses[0])")
            return
        }
        
        guard case .serviceError = statuses[1] else {
            XCTFail("Expected .error, but got \(statuses[1])")
            return
        }
    }
    
    func test_whenArtistLookupServiceReturns_theUseCaseShouldReturnTheExpectedStatesAndItems() {
        // Given
        let itemsToReturn: [ArtistLookupResponseEntity.Result] = [
            ArtistLookupResponseEntity.Result.fixture(
                wrapperType: .track,
                primaryGenreName: "primaryGenreName 1",
                artistName: "artistName 1",
                trackName: "trackName 1"
            ),
            ArtistLookupResponseEntity.Result.fixture(
                wrapperType: .track,
                primaryGenreName: "primaryGenreName 2",
                artistName: "artistName 2",
                trackName: "trackName 2"
            )
        ]
        let artistLookupServiceProviderStub = ArtistLookupServiceProviderStub(
            resultToReturn: .success(itemsToReturn)
        )
        let sut = FetchShuffledMusicListUseCase(artistLookupService: artistLookupServiceProviderStub)
        let expectedEventsCount = 2
        var eventsCollected = [UseCaseEvent<[MusicInfoItem], FetchShuffledMusicListUseCaseError>]()
        
        // When
        let executeExpectation = expectation(description: "executeExpectation")
        sut.execute { event in
            eventsCollected.append(event)
            if eventsCollected.count == expectedEventsCount {
                executeExpectation.fulfill()
            }
        }
        wait(for: [executeExpectation], timeout: 1.0)
        
        // Then
        let statuses = eventsCollected.map { $0.status }
        guard case .loading = statuses[0] else {
            XCTFail("Expected .loading, but got \(statuses[0])")
            return
        }
        
        guard case let .data(dataItems) = statuses[1] else {
            XCTFail("Expected .data, but got \(statuses[1])")
            return
        }
        
        XCTAssertEqual(itemsToReturn.count, dataItems.count, "Expected to return \(itemsToReturn.count), but got \(dataItems.count)")
    }
    
    func test_whenArtistLookupServiceReturnsItemsThatAreNotTracksOrDontHaveTrackname_theUseCaseShouldReturnTheExpectedItems() {
        // Given
        let itemsToReturn: [ArtistLookupResponseEntity.Result] = [
            ArtistLookupResponseEntity.Result.fixture(
                wrapperType: .artist,
                primaryGenreName: "primaryGenreName 1",
                artistName: "artistName 1",
                trackName: "trackName 1"
            ),
            ArtistLookupResponseEntity.Result.fixture(
                wrapperType: .track,
                primaryGenreName: "primaryGenreName 2",
                artistName: "artistName 2",
                trackName: nil
            )
        ]
        let artistLookupServiceProviderStub = ArtistLookupServiceProviderStub(
            resultToReturn: .success(itemsToReturn)
        )
        let sut = FetchShuffledMusicListUseCase(artistLookupService: artistLookupServiceProviderStub)
        let expectedEventsCount = 2
        var eventsCollected = [UseCaseEvent<[MusicInfoItem], FetchShuffledMusicListUseCaseError>]()
        
        // When
        let executeExpectation = expectation(description: "executeExpectation")
        sut.execute { event in
            eventsCollected.append(event)
            if eventsCollected.count == expectedEventsCount {
                executeExpectation.fulfill()
            }
        }
        wait(for: [executeExpectation], timeout: 1.0)
        
        // Then
        let statuses = eventsCollected.map { $0.status }
        guard case let .data(dataItems) = statuses[1] else {
            XCTFail("Expected .data, but got \(statuses[1])")
            return
        }
        
        XCTAssertEqual(0, dataItems.count, "Expected to return 0, but got \(dataItems.count)")
    }
    
}

// MARK: - Testing Helpers

private final class ArtistLookupServiceProviderStub: ArtistLookupServiceProvider {
    
    let resultToReturn: Result<[ArtistLookupResponseEntity.Result], ArtistLookupServiceError>
    
    init(resultToReturn: Result<[ArtistLookupResponseEntity.Result], ArtistLookupServiceError>) {
        self.resultToReturn = resultToReturn
    }
    
    func lookupArtistsWithIDs(_ ids: [String], completion: @escaping (Result<[ArtistLookupResponseEntity.Result], ArtistLookupServiceError>) -> Void) {
        completion(resultToReturn)
    }
    
}

private final class ArtistLookupServiceProviderSpy: ArtistLookupServiceProvider {
    
    private(set) var lookupArtistsWithIDsCalled = false
    private(set) var idsPassed: [String]?
    func lookupArtistsWithIDs(_ ids: [String], completion: @escaping (Result<[ArtistLookupResponseEntity.Result], ArtistLookupServiceError>) -> Void) {
        lookupArtistsWithIDsCalled = true
        idsPassed = ids
    }
    
}
