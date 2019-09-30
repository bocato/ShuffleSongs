//
//  MemoryCacheService.swift
//  CachingTests
//
//  Created by Eduardo Sanches Bocato on 29/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import Caching

final class MemoryCacheServiceTests: XCTestCase {

    // MARK: - Properties

    var sut: MemoryCacheService!

    // MARK: - Test Lifecycle

    override func tearDown() {
        super.tearDown()
        sut.clear()
        sut = nil
    }

    // MARK: - Memory Cache Tests

    func test_memoryCache_saveData_shoulSucceed() {
        // Given
        sut = MemoryCacheService()
        guard let dataToSave = "value".data(using: .utf8) else {
            XCTFail("Could not create `dataToSave`.")
            return
        }
        let key = "Save-Memory-Tests"

        // When
        let saveDataExpectation = expectation(description: "saveDataExpectation")
        var savingSucceeded = false
        var errorThrown: Error?
        sut.save(data: dataToSave, key: key) { (result) in
            switch result {
            case let .failure(error):
                errorThrown = error
            case .success:
                savingSucceeded = true
            }
            saveDataExpectation.fulfill()
        }
        wait(for: [saveDataExpectation], timeout: 1.0)

        // Then
        XCTAssertTrue(savingSucceeded, "Expected to succeed, but \(errorThrown.debugDescription)) was thrown.")
    }

    func test_memoryCache_loadingDataForValidKey_shouldSucceed() {
        // Given
        sut = MemoryCacheService()
        guard let dataToSave = "value".data(using: .utf8) else {
            XCTFail("Could not create `dataToSave`.")
            return
        }
        let key = "Load-Memory-Tests"
        sut.save(data: dataToSave, key: key)

        // When
        let loadDataExpectation = expectation(description: "loadDataExpectation")
        var errorThrown: Error?
        var dataLoaded: Data?
        sut.loadData(from: key){ result in
            switch result {
            case let .failure(error):
                errorThrown = error
            case let .success(data):
                dataLoaded = data
            }
            loadDataExpectation.fulfill()
        }
        wait(for: [loadDataExpectation], timeout: 1.0)

        // Then
        XCTAssertNotNil(dataLoaded, "Expected some data, but \(errorThrown.debugDescription)) was thrown.")
    }

    func test_memoryCache_loadingInvalidData_shouldSucceed() {
        // Given
        sut = MemoryCacheService()
        let key = "LoadFail-Memory-Tests"

        // When
        let loadDataExpectation = expectation(description: "loadDataExpectation")
        var errorThrown: Error?
        var dataLoaded: Data?
        sut.loadData(from: key){ result in
            switch result {
            case let .failure(error):
                errorThrown = error
            case let .success(data):
                dataLoaded = data
            }
            loadDataExpectation.fulfill()
        }
        wait(for: [loadDataExpectation], timeout: 1.0)

        // Then
        XCTAssertNil(dataLoaded, "Expected some data, but \(errorThrown.debugDescription)) was thrown.")
    }

    func test_memoryCache_clear_shouldSucceed() {
        // Given
        sut = MemoryCacheService()
        guard let dataToSave = "value".data(using: .utf8) else {
            XCTFail("Could not create `dataToSave`.")
            return
        }
        let key = "Clear-Memory-Tests"
        sut.save(data: dataToSave, key: key)
        sut.clear()

        // When
        let loadDataExpectation = expectation(description: "loadDataExpectation")
        var loadFailed = false
        sut.loadData(from: key) { result in
            guard case .failure = result else {
                loadDataExpectation.fulfill()
                return
            }
            loadFailed = true
            loadDataExpectation.fulfill()
        }
        wait(for: [loadDataExpectation], timeout: 1.0)

        // Then
        XCTAssertTrue(loadFailed, "Load should have failed.")
    }

}
