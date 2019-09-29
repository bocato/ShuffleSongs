//
//  MusicListTableViewCellTests.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 29/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

import XCTest
@testable import ShuffleSongs
import Networking

final class MusicListTableViewCellTests: XCTestCase {

    func test_onPrepareForReuse_imageRequestShouldBeCancelled() {
        // Given
        let sut = MusicListTableViewCell()
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
        let viewModel = MusicListTableViewCellViewModel(
            dataModel: dataModelMock,
            imagesService: imagesServiceProviderStub
        )
        sut.configure(with: viewModel)

        // When
        sut.prepareForReuse()
        
        // Then
        XCTAssertTrue(imagesServiceProviderStub.urlRequestTokenSpy.cancelCalled, "`cancel` should have been called on request token.")
    }
    
    func test_onConfigure_fetchImageShouldBeCalled() {
        // Given
        let sut = MusicListTableViewCell()
        let dataModelMock = MusicListItemViewData(
            imageURL: "http://www.someimageurl.com/image.jpg",
            title: "title",
            subtitle: "subtitle"
        )
        let imagesServiceProviderSpy = ImagesServiceProviderSpy()
        let viewModel = MusicListTableViewCellViewModel(
            dataModel: dataModelMock,
            imagesService: imagesServiceProviderSpy
        )
        // When
        sut.configure(with: viewModel)
        
        
        // Then
        XCTAssertTrue(imagesServiceProviderSpy.getImageDataFromURLCalled, "`getImageDataFromURL` should have been called.")
    }

}

// MARK: - Testing Helpers

final class ImagesServiceProviderSpy: ImagesServiceProvider {
    
    private(set) var getImageDataFromURLCalled = false
    private(set) var urlStringPassed: String?
    func getImageDataFromURL(_ urlString: String, completion: @escaping (Result<Data, ImagesServiceError>) -> Void) -> URLRequestToken? {
        getImageDataFromURLCalled = true
        urlStringPassed = urlString
        return nil
    }
    
}
