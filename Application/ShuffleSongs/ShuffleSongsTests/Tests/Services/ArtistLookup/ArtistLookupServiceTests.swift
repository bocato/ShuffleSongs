//
//  ArtistLookupServiceTests.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 28/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import ShuffleSongs
import Networking

final class ArtistLookupServiceTests: XCTestCase {
    
    func test_whenRequestFails_theErrorShouldBeTransformedToArtistLookupServiceError() {
        // Given
        let urlRequestDispatchingStub = URLRequestDispatchingStub(
            resultToReturn: .failure(.unknown)
        )
        let sut = ArtistLookupService(dispatcher: urlRequestDispatchingStub)
        
        // When
        let lookupArtistsWithIDsExpectation = expectation(description: "lookupArtistsWithIDsExpectation")
        var resultReturned: Result<[ArtistLookupResponseEntity.Result], ArtistLookupServiceError>?
        sut.lookupArtistsWithIDs([]) { (result) in
            resultReturned = result
            lookupArtistsWithIDsExpectation.fulfill()
        }
        wait(for: [lookupArtistsWithIDsExpectation], timeout: 1.0)
        
        // Then
        guard case let .failure(error) = resultReturned else {
            XCTFail("Expected .failure, but got something else.")
            return
        }
        
        guard case .networking = error else {
            XCTFail("Expected .networking, but got \(error).")
            return
        }
    }
    
    func test_whenRequestSucceeds_theWheShouldReceiveTheResultsPropertyfromTheEntity() {
        // Given
        let entityToReturn = ArtistLookupResponseEntity(
            resultCount: 1,
            results: [.fixture(id: 1), .fixture(id: 2)]
        )
        guard let entityDataToReturn = try? JSONEncoder().encode(entityToReturn) else {
            XCTFail("Could not create `entityData`.")
            return
        }
        let resultToReturn: Result<Data?, URLRequestError> = .success(entityDataToReturn)
        let urlRequestDispatchingStub = URLRequestDispatchingStub(
            resultToReturn: resultToReturn
        )
        let sut = ArtistLookupService(dispatcher: urlRequestDispatchingStub)
        
        // When
        let lookupArtistsWithIDsExpectation = expectation(description: "lookupArtistsWithIDsExpectation")
        var resultReturned: Result<[ArtistLookupResponseEntity.Result], ArtistLookupServiceError>?
        sut.lookupArtistsWithIDs([]) { (result) in
            resultReturned = result
            lookupArtistsWithIDsExpectation.fulfill()
        }
        wait(for: [lookupArtistsWithIDsExpectation], timeout: 1.0)
        
        // Then
        guard case let .success(valuesReturned) = resultReturned else {
            XCTFail("Expected .failure, but got something else.")
            return
        }
        XCTAssertEqual(valuesReturned.count, 2, "Expected 2values, but got \(valuesReturned.count).")
        XCTAssertEqual(entityToReturn.results.first?.id, valuesReturned.first?.id, "Expected \(String(describing: entityToReturn.results.first?.id)), but got \(String(describing: valuesReturned.first?.id)).")
        XCTAssertEqual(entityToReturn.results.last?.id, valuesReturned.last?.id, "Expected \(String(describing: entityToReturn.results.last?.id)), but got \(String(describing: valuesReturned.last?.id)).")
    }
    
}

// MARK: - TestingHelpers

final class URLRequestDispatchingStub: URLRequestDispatching {
    
    private let resultToReturn: Result<Data?, URLRequestError>
    
    init(resultToReturn: Result<Data?, URLRequestError>) {
        self.resultToReturn = resultToReturn
    }
    
    func execute(request: URLRequestProtocol, completion: @escaping (Result<Data?, URLRequestError>) -> Void) -> URLRequestToken? {
        completion(resultToReturn)
        return nil
    }
    
}
