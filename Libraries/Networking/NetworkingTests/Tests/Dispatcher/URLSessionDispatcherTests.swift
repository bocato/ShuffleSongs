//
//  URLSessionDispatcherTests.swift
//  NetworkingTests
//
//  Created by Eduardo Sanches Bocato on 30/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import Networking

final class URLSessionDispatcherTests: XCTestCase {
    
    func test_invalidURL_shouldReturnRequestBuildeFailureError() {
        // Given
        let sut = URLSessionDispatcher(requestBuilderType: URLRequestBuilderErrorReturningMock.self)
        guard let url = URL(string: "http://www.someurl.com/") else {
            XCTFail("Could not create URL.")
            return
        }
        let request: SimpleURLRequest = .init(url: url)

        // When
        let executeRequestExpectation = expectation(description: "executeRequestExpectation")
        var errorThrown: Error?
        sut.execute(request: request) { (result) in
            do {
                _ = try result.get()
            } catch {
                errorThrown = error
            }
            executeRequestExpectation.fulfill()
        }
        wait(for: [executeRequestExpectation], timeout: 1.0)

        // Then
        XCTAssertNotNil(errorThrown, "An error, should have been thrown.")
        guard case .requestBuilderFailed = errorThrown as? URLRequestError else {
            XCTFail("Invalid error found, expected `URLRequestError.requestBuilderFailed`.")
            return
        }
    }
    
}

// MARK: - Testing Helpers

private final class URLRequestBuilderErrorReturningMock: URLRequestBuilder {
    
    init(request: URLRequestProtocol) {}
    init(with baseURL: URL, path: String?) {}
    func set(method: HTTPMethod) -> Self { return self }
    func set(path: String) -> Self { return self }
    func set(headers: [String : String]?) -> Self { return self }
    func set(parameters: URLRequestParameters?) -> Self { return self }
    func add(adapter: URLRequestAdapter) -> Self { return self }
    
    func build() throws -> URLRequest {
        throw NSError()
    }
    
}
