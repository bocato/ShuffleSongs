//
//  MusicListTableViewCellViewModelTests.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 28/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import ShuffleSongs
import Networking

final class MusicListTableViewCellViewModelTests: XCTestCase {
    
    func test_whenTitleIsCalled_itShouldReturnTheSameValuePresentOnDataModel() {
        // Given
        let dataModelMock = MusicListItemViewData(
            imageURL: nil,
            title: "title",
            subtitle: "subtitle"
        )
        let sut = MusicListTableViewCellViewModel(
            dataModel: dataModelMock,
            imagesService: ImagesServiceProviderDummy()
        )
        
        // When
        let title = sut.title
        
        // Then
        XCTAssertEqual(dataModelMock.title, title, "Expected \(dataModelMock.title), but got \(title)")
    }
    
    func test_whenSubititleIsCalled_itShouldReturnTheSameValuePresentOnDataModel() {
        // Given
        let dataModelMock = MusicListItemViewData(
            imageURL: nil,
            title: "title",
            subtitle: "subtitle"
        )
        let sut = MusicListTableViewCellViewModel(
            dataModel: dataModelMock,
            imagesService: ImagesServiceProviderDummy()
        )
        
        // When
        let subtitle = sut.subtitle
        
        // Then
        XCTAssertEqual(dataModelMock.subtitle, subtitle, "Expected \(dataModelMock.subtitle), but got \(subtitle)")
    }
    
    func test_whenFetchImageIsCalled_forInvalidURL_itShouldReturnLogo() {
        // Given
        let dataModelMock = MusicListItemViewData(
            imageURL: nil,
            title: "title",
            subtitle: "subtitle"
        )
        let sut = MusicListTableViewCellViewModel(
            dataModel: dataModelMock,
            imagesService: ImagesServiceProviderDummy()
        )
        
        // When
        let fetchImageExpectation = expectation(description: "fetchImageExpectation")
        var fetchedImage: UIImage?
        sut.fetchImage { image in
            fetchedImage = image
            fetchImageExpectation.fulfill()
        }
        wait(for: [fetchImageExpectation], timeout: 1.0)
        
        // Then
        XCTAssertNotNil(fetchedImage, "Expected to receive an image.")
        XCTAssertEqual(fetchedImage, UIImage.logo, "Expected to receive `logo`, but got \(fetchedImage.debugDescription)")
    }
    
    func test_whenFetchImageIsCalled_butThereIsAnImagesServiceError_itShouldReturnLogo() {
        // Given
        let dataModelMock = MusicListItemViewData(
            imageURL: "http://www.someimageurl.com/image.jpg",
            title: "title",
            subtitle: "subtitle"
        )
        let imagesServiceProviderStub = ImagesServiceProviderStub(resultToReturn: .failure(.emptyData))
        let sut = MusicListTableViewCellViewModel(
            dataModel: dataModelMock,
            imagesService: imagesServiceProviderStub
        )
        
        // When
        let fetchImageExpectation = expectation(description: "fetchImageExpectation")
        var fetchedImage: UIImage?
        sut.fetchImage { image in
            fetchedImage = image
            fetchImageExpectation.fulfill()
        }
        wait(for: [fetchImageExpectation], timeout: 1.0)
        
        // Then
        XCTAssertNotNil(fetchedImage, "Expected to receive an image.")
        XCTAssertEqual(fetchedImage, UIImage.logo, "Expected to receive `logo`, but got \(fetchedImage.debugDescription)")
    }
    
    func test_whenFetchImageIsCalledSuccessfully_itShouldReturnTheExpectedData() {
        // Given
        let dataModelMock = MusicListItemViewData(
            imageURL: "http://www.someimageurl.com/image.jpg",
            title: "title",
            subtitle: "subtitle"
        )
        guard let expectedImageData = UIImage.logo.pngData() else {
            XCTFail("Could not create `expectedImageData`")
            return
        }
        let imagesServiceProviderStub = ImagesServiceProviderStub(resultToReturn: .success(expectedImageData))
        let sut = MusicListTableViewCellViewModel(
            dataModel: dataModelMock,
            imagesService: imagesServiceProviderStub
        )
        
        // When
        let fetchImageExpectation = expectation(description: "fetchImageExpectation")
        var fetchedImageData: Data?
        sut.fetchImage { image in
            fetchedImageData = image.pngData()
            fetchImageExpectation.fulfill()
        }
        wait(for: [fetchImageExpectation], timeout: 1.0)
        
        // Then
        XCTAssertNotNil(fetchedImageData, "Expected to receive an image with valid data.")
    }
    
    func test_whenCancelImageRequestIsCalled_theURLRequestTokenShouldBeCancelled() {
        // Given
        let dataModelMock = MusicListItemViewData(
            imageURL: "http://www.someimageurl.com/image.jpg",
            title: "title",
            subtitle: "subtitle"
        )
        guard let expectedImageData = UIImage.logo.pngData() else {
            XCTFail("Could not create `expectedImageData`")
            return
        }
        let imagesServiceProviderStub = ImagesServiceProviderStub(resultToReturn: .success(expectedImageData))
        let sut = MusicListTableViewCellViewModel(
            dataModel: dataModelMock,
            imagesService: imagesServiceProviderStub
        )
        let fetchImageExpectation = expectation(description: "fetchImageExpectation")
        sut.fetchImage { _ in
            fetchImageExpectation.fulfill()
        }
        wait(for: [fetchImageExpectation], timeout: 1.0)
        
        // When
        sut.cancelImageRequest()
        
        // Then
        let cancelCalled = imagesServiceProviderStub.urlRequestTokenSpy.cancelCalled
        XCTAssertTrue(cancelCalled, "`imageRequestToken?.cancel()` should have been called.")
    }
    
}

// MARK: - Testing Helpers

private final class ImagesServiceProviderStub: ImagesServiceProvider {
    
    let resultToReturn: Result<Data, ImagesServiceError>
    let urlRequestTokenSpy = URLRequestTokenSpy()
    
    init(resultToReturn: Result<Data, ImagesServiceError>) {
        self.resultToReturn = resultToReturn
    }
    
    func getImageDataFromURL(_ urlString: String, completion: @escaping (Result<Data, ImagesServiceError>) -> Void) -> URLRequestToken? {
        completion(resultToReturn)
        return urlRequestTokenSpy
    }
    
}

private final class URLRequestTokenSpy: URLRequestToken {
    private(set) var cancelCalled = false
    func cancel() {
        cancelCalled = true
    }
}

