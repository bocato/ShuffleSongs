//
//  EnvironmentTests.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 28/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import ShuffleSongs

final class EnvironmentTests: XCTestCase {
    
    func test_environment_souldStartAsDev() {
        // Given
        let expectedCurrentEnviroment: EnvironmentType = .development
        guard let expectedBaseURL = URL(string: "https://us-central1-tw-exercicio-mobile.cloudfunctions.net") else {
            XCTFail("Could not instantiate baseURL.")
            return
        }
        let sut: EnvironmentProvider = Environment.shared
        
        // When
        let currentEnvironment = sut.currentEnvironment
        let baseURL = sut.baseURL
        
        // Then
        XCTAssertEqual(currentEnvironment.rawValue, expectedCurrentEnviroment.rawValue, "The Environments should the same.")
        XCTAssertEqual(baseURL, expectedBaseURL, "The baseURL's should the same.")
    }
    
    func test_whenCurrentEnvironment_isSetItShouldUpdateItsValues() {
        // Given
        let expectedCurrentEnviroment: EnvironmentType = .development
        var sut: EnvironmentProvider = Environment.shared
        
        // When
        sut.currentEnvironment = .development
        
        // Then
        XCTAssertEqual(expectedCurrentEnviroment.rawValue, sut.currentEnvironment.rawValue, "The Environments should the same.")
    }
    
}
