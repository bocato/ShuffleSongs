//
//  DiskCacheServiceTests.swift
//  CachingTests
//
//  Created by Eduardo Sanches Bocato on 30/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import Caching

final class DiskCacheServiceTests: XCTestCase {

    // MARK: - Properties

    var sut: DiskCacheService!

    // MARK: - Test Lifecycle

    override func tearDown() {
        super.tearDown()
        sut.clear()
        sut = nil
    }

    // MARK: - Tests

    func test_diskCache_saveData_shoulSucceed() {
        // Given
        guard let diskCache = try? DiskCacheService(cacheDirectoryName: "DiskCache") else {
            XCTFail("Could not create DiskCacheService.")
            return
        }
        sut = diskCache
        guard let dataToSave = "value".data(using: .utf8) else {
            XCTFail("Could not create `dataToSave`.")
            return
        }
        let key = "Save-Disk-Tests"

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

    func test_diskCache_loadingDataForValidKey_shouldSucceed() {
        // Given
        guard let diskCache = try? DiskCacheService(cacheDirectoryName: "DiskCache") else {
            XCTFail("Could not create DiskCacheService.")
            return
        }
        sut = diskCache
        guard let dataToSave = "value".data(using: .utf8) else {
            XCTFail("Could not create `dataToSave`.")
            return
        }
        let key = "Load-Disk-Tests"
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

    func test_diskCache_loadingInvalidData_shouldSucceed() {
        // Given
        guard let diskCache = try? DiskCacheService(cacheDirectoryName: "DiskCache") else {
            XCTFail("Could not create DiskCacheService.")
            return
        }
        sut = diskCache
        let key = "LoadFail-Disk-Tests"

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

    func test_diskCache_clear_shouldSucceed() {
        // Given
        guard let diskCache = try? DiskCacheService(cacheDirectoryName: "DiskCache") else {
            XCTFail("Could not create DiskCacheService.")
            return
        }
        sut = diskCache
        guard let dataToSave = "value".data(using: .utf8) else {
            XCTFail("Could not create `dataToSave`.")
            return
        }
        let key = "Clear-Disk-Tests"
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
