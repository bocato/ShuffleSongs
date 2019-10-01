//
//  URLRequestErrorTests.swift
//  NetworkingTests
//
//  Created by Eduardo Sanches Bocato on 30/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import Networking

final class URLRequestErrorTests: XCTestCase {

    // MARK: - Error Code Tests
    
    func test_raw_error() {
        // Given
        let rawError = NSError(domain: "NetworkingError", code: 123, description: "description")
        
        // When
        let sut = URLRequestError.raw(rawError).rawError
        
        // Then
        XCTAssertEqual(rawError, sut, "Expected \(rawError), but got \(sut).")
    }
    
    func test_unknown_errorCode() {
        // Given
        let rawError = NSError(domain: "URLRequestError", code: -1, description: "Unknown error.")
        
        // When
        let sut = URLRequestError.unknown.rawError
        
        // Then
        XCTAssertEqual(rawError, sut, "Expected \(rawError), but got \(sut).")
    }
    
    func test_requestBuilderFailed_errorCode() {
        // Given
        let rawError = NSError(domain: "URLRequestError", code: -2, description: "The request builder failed.")
        
        // When
        let sut = URLRequestError.requestBuilderFailed.rawError
        
        // Then
        XCTAssertEqual(rawError, sut, "Expected \(rawError), but got \(sut).")
    }
    
    func test_withData_andErrorNotNil_errorCode() {
        // Given
        guard let errorData = """
        {"someValue": "value"}
        """.data(using: .utf8) else {
            XCTFail("Could not create `errorData`.")
            return
        }
        let originalError = NSError(domain: "URLRequestError", code: 123, description: "description")
        let expectedError = NSError(
            domain: "URLRequestError",
            code: 123,
            userInfo: [
                "originalError": originalError,
                "errorJSON": ["someValue":  "value"]
            ]
        )
        
        // When
        let sut = URLRequestError.withData(errorData, originalError).rawError
        
        // Then
        XCTAssertEqual(expectedError, sut, "Expected \(expectedError), but got \(sut).")
    }
    
    func test_withData_andNilError_errorCode() {
        // Given
        guard let errorData = """
        {"someValue": "value"}
        """.data(using: .utf8) else {
            XCTFail("Could not create `errorData`.")
            return
        }
        let expectedError = NSError(
            domain: "URLRequestError",
            code: -3,
            userInfo: ["errorJSON": ["someValue":  "value"]]
        )
        
        // When
        let sut = URLRequestError.withData(errorData, nil).rawError
        
        // Then
        XCTAssertEqual(expectedError, sut, "Expected \(expectedError), but got \(sut).")
    }
    
    func test_invalidHTTPURLResponse_errorCode() {
        
        // Given
        let expectedCode = -4
        let sut: URLRequestError = .invalidHTTPURLResponse
        
        // When / Then
        XCTAssertEqual(expectedCode, sut.code, "Expected \(expectedCode), but got \(sut.code).")
    }
    
}
