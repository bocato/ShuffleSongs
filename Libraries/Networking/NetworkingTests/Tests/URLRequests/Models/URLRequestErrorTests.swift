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
    
    func test_raw_errorCode() {
        // Given
        let rawError = NSError(domain: "domain", code: 123, description: "description")
        let sut: URLRequestError = .raw(rawError)
        
        // When / Then
        XCTAssertEqual(rawError.code, sut.code, "Expected \(rawError.code), but got \(sut.code).")
    }
    
    func test_unknown_errorCode() {
        // Given
        let expectedCode = -1
        let sut: URLRequestError = .unknown
        
        // When / Then
        XCTAssertEqual(expectedCode, sut.code, "Expected \(expectedCode), but got \(sut.code).")
    }
    
    func test_requestBuilderFailed_errorCode() {
        // Given
        let expectedCode = -2
        let sut: URLRequestError = .requestBuilderFailed
        
        // When / Then
        XCTAssertEqual(expectedCode, sut.code, "Expected \(expectedCode), but got \(sut.code).")
    }
    
    func test_withData_andErrorNotNil_errorCode() {
        // Given
        let rawError = NSError(domain: "domain", code: 123, description: "description")
        let sut: URLRequestError = .withData(Data(), rawError)
        
        // When / Then
        XCTAssertEqual(rawError.code, sut.code, "Expected \(rawError.code), but got \(sut.code).")
    }
    
    func test_withData_andNilError_errorCode() {
        // Given
        let expectedCode = -3
        let sut: URLRequestError = .withData(Data(), nil)
        
        // When / Then
        XCTAssertEqual(expectedCode, sut.code, "Expected \(expectedCode), but got \(sut.code).")
    }
    
    func test_invalidHTTPURLResponse_errorCode() {
        // Given
        let expectedCode = -4
        let sut: URLRequestError = .invalidHTTPURLResponse
        
        // When / Then
        XCTAssertEqual(expectedCode, sut.code, "Expected \(expectedCode), but got \(sut.code).")
    }
    
    // MARK: - RawError Tests
    
    
}
