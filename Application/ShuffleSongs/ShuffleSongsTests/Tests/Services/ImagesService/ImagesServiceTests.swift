//
//  ImagesServiceTests.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 28/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import ShuffleSongs
import Networking
import Caching

final class ImagesServiceTests: XCTestCase {
    
    func test_whenRequestingImageWithAndInvalidURL_itShouldReturnAnInvalidURLError() {
        // Given
        let sut = ImagesService(
            dispatcher: URLRequestDispatchingDummy(),
            cacheService: CacheServiceProviderDummy()
        )
        let invalidURLString = ""
        
        // When
        let getImageDataFromURLExpectation = expectation(description: "getImageDataFromURLExpectation")
        var resultReturned: Result<Data, ImagesServiceError>?
        sut.getImageDataFromURL(invalidURLString) { result in
            resultReturned = result
            getImageDataFromURLExpectation.fulfill()
        }
        wait(for: [getImageDataFromURLExpectation], timeout: 1.0)
        
        // Then
        guard case let .failure(error) = resultReturned else {
            XCTFail("Expected .failure, but got \(String(describing: resultReturned))")
            return
        }
        
        guard case let .invalidURL(url) = error else {
            XCTFail("Expected .invalidURL, but got \(String(describing: resultReturned))")
            return
        }
        
        XCTAssertEqual(invalidURLString, url, "Expected \(invalidURLString), but got \(url).")
    }
    
    func test_whenRequestingSomethingThatIsOnCache_itShouldReturnTheDataFromTheCache() {
        // Given
        let dataToReturn = Data()
        let cacheServiceProviderStub = CacheServiceProviderStub(
            loadDataResultToReturn: .success(dataToReturn)
        )
        let sut = ImagesService(
            dispatcher: URLRequestDispatchingDummy(),
            cacheService: cacheServiceProviderStub
        )
        
        // When
        let getImageDataFromURLExpectation = expectation(description: "getImageDataFromURLExpectation")
        var resultReturned: Result<Data, ImagesServiceError>?
        sut.getImageDataFromURL("http://www.someimage.com/img.jpg") { result in
            resultReturned = result
            getImageDataFromURLExpectation.fulfill()
        }
        wait(for: [getImageDataFromURLExpectation], timeout: 1.0)
        
        // Then
        guard case let .success(data) = resultReturned else {
            XCTFail("Expected .success, but got \(String(describing: resultReturned))")
            return
        }
        
        XCTAssertEqual(dataToReturn, data, "Expected \(dataToReturn.debugDescription), but got \(data.debugDescription)")
    }
    
    func test_whenRequestingSomethingFromNetworkgAndItReturnsNillData_itShouldReturnEmptyDataError() {
        // Given
        let cacheServiceProviderStub = CacheServiceProviderStub(
            loadDataResultToReturn: .failure(.couldNotLoadData)
        )
        let urlRequestDispatchingStub = URLRequestDispatchingStub(
            resultToReturn: .success(nil)
        )
        let sut = ImagesService(
            dispatcher: urlRequestDispatchingStub,
            cacheService: cacheServiceProviderStub
        )
        
        // When
        let getImageDataFromURLExpectation = expectation(description: "getImageDataFromURLExpectation")
        var resultReturned: Result<Data, ImagesServiceError>?
        sut.getImageDataFromURL("http://www.someimage.com/img.jpg") { result in
            resultReturned = result
            getImageDataFromURLExpectation.fulfill()
        }
        wait(for: [getImageDataFromURLExpectation], timeout: 1.0)
        
        // Then
        guard case let .failure(error) = resultReturned else {
            XCTFail("Expected .failure, but got \(String(describing: resultReturned))")
            return
        }
        
        guard case .emptyData = error else {
            XCTFail("Expected .emptyData, but got \(String(describing: error))")
            return
        }
    }
    
    func test_whenRequestingSomethingFromNetworkgAndItReturnsAnError_itShouldReturnNetworkError() {
        // Given
        let cacheServiceProviderStub = CacheServiceProviderStub(
            loadDataResultToReturn: .failure(.couldNotLoadData)
        )
        let urlRequestDispatchingStub = URLRequestDispatchingStub(
            resultToReturn: .failure(.unknown)
        )
        let sut = ImagesService(
            dispatcher: urlRequestDispatchingStub,
            cacheService: cacheServiceProviderStub
        )
        
        // When
        let getImageDataFromURLExpectation = expectation(description: "getImageDataFromURLExpectation")
        var resultReturned: Result<Data, ImagesServiceError>?
        sut.getImageDataFromURL("http://www.someimage.com/img.jpg") { result in
            resultReturned = result
            getImageDataFromURLExpectation.fulfill()
        }
        wait(for: [getImageDataFromURLExpectation], timeout: 1.0)
        
        // Then
        guard case let .failure(error) = resultReturned else {
            XCTFail("Expected .failure, but got \(String(describing: resultReturned))")
            return
        }
        
        guard case .network = error else {
            XCTFail("Expected .network, but got \(String(describing: error))")
            return
        }
    }
    
    func test_whenRequestingSomethingFromNetworkgAndItReturnsValidData_itShouldReturnValidDataAndSaveOnCache() {
        // Given
        let dataToReturn = Data()
        let cacheServiceProviderStub = CacheServiceProviderStub(
            loadDataResultToReturn: .failure(.couldNotLoadData)
        )
        let urlRequestDispatchingStub = URLRequestDispatchingStub(
            resultToReturn: .success(dataToReturn)
        )
        let sut = ImagesService(
            dispatcher: urlRequestDispatchingStub,
            cacheService: cacheServiceProviderStub
        )
        
        // When
        let getImageDataFromURLExpectation = expectation(description: "getImageDataFromURLExpectation")
        var resultReturned: Result<Data, ImagesServiceError>?
        sut.getImageDataFromURL("http://www.someimage.com/img.jpg") { result in
            resultReturned = result
            getImageDataFromURLExpectation.fulfill()
        }
        wait(for: [getImageDataFromURLExpectation], timeout: 1.0)
        
        // Then
        guard case let .success(data) = resultReturned else {
            XCTFail("Expected .failure, but got \(String(describing: resultReturned))")
            return
        }
        
        XCTAssertTrue(cacheServiceProviderStub.saveCalled, "Save `cache.save` should have been called.")
        XCTAssertEqual(dataToReturn, data, "Expected \(dataToReturn.debugDescription), but got \(data.debugDescription)")
    }
    
}

// MARK: - Testing Helpers

private final class URLRequestDispatchingDummy: URLRequestDispatching {
    func execute(request: URLRequestProtocol, completion: @escaping (Result<Data?, URLRequestError>) -> Void) -> URLRequestToken? {
        completion(.success(nil))
        return nil
    }
}

private final class CacheServiceProviderDummy: CacheServiceProvider {
    init() {}
    init(fileManager: FileManager, cacheType: CacheType, cacheDirectoryName: String) {}
    func save(data: Data, key: String, completion: ((Result<Void, CacheServiceError>) -> Void)?) {}
    func loadData(from key: String, completion: ((Result<Data, CacheServiceError>) -> Void)) {}
    func clear(_ completion: ((Result<Void, CacheServiceError>) -> Void)?) {}
}

private final class CacheServiceProviderStub: CacheServiceProvider {
    
    init(fileManager: FileManager, cacheType: CacheType, cacheDirectoryName: String) {
        loadDataResultToReturn = .success(Data())
    }
    
    private(set) var saveCalled = false
    func save(data: Data, key: String, completion: ((Result<Void, CacheServiceError>) -> Void)?) {
        saveCalled = true
    }
    
    private let loadDataResultToReturn: Result<Data, CacheServiceError>
    init(loadDataResultToReturn: Result<Data, CacheServiceError>) {
        self.loadDataResultToReturn =  loadDataResultToReturn
    }
    
    func loadData(from key: String, completion: ((Result<Data, CacheServiceError>) -> Void)) {
        completion(loadDataResultToReturn)
    }
    
    func clear(_ completion: ((Result<Void, CacheServiceError>) -> Void)?) {}
}
