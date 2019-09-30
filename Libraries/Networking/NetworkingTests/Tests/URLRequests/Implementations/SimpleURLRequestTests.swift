//
//  SimpleURLRequestTests.swift
//  NetworkingTests
//
//  Created by Eduardo Sanches Bocato on 30/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import Networking

final class SimpleURLRequestTests: XCTestCase {
    
    func test_simpleURLRequest_shouldBuildExpectedRequestObject() {
        // Given
        guard let url = URL(string: "http://www.someurl.com/") else {
            XCTFail("Could not create URL.")
            return
        }
        let sut: SimpleURLRequest = .init(url: url)
        
        // When
        let request = try? sut.build()
        
        // Then
        XCTAssertNotNil(request, "Expected a valid request.")
        XCTAssertEqual(url, request?.url, "Expected \(url), but got \(String(describing: request?.url))")
    }
    
}
