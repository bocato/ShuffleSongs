//
//  SceneDelegateTests.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 28/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import ShuffleSongs
import Caching
import Networking

final class SceneDelegateTests: XCTestCase {
    
    func test_setupRootViewController_theRootControllerConfigured() {
        // Given
        let sceneDelegate = SceneDelegate()
        
        // When
        sceneDelegate.setupRootViewController(windowScene: nil)
        
        // Then
        let rootViewController = sceneDelegate.window?.rootViewController as? UINavigationController
        XCTAssertTrue(rootViewController is ShuffleSongsNavigationController, "The rootViewController should be a `ShuffleSongsNavigationController`")
        let firstControllerOfRootNavigation = rootViewController?.viewControllers.first
        XCTAssertTrue(firstControllerOfRootNavigation is MusicListViewController, "The firstController of the RootController should be a `MusicListViewController`")
    }
    
    func theCachesShouldBeCleaned() {
        // Given
        let cacheServiceProviderSpy = CacheServiceProviderSpy()
        let sceneDelegate = SceneDelegate()
        sceneDelegate.cache = cacheServiceProviderSpy
        
        // When
        sceneDelegate.setupRootViewController(windowScene: nil)
        
        // Then
        XCTAssertTrue(cacheServiceProviderSpy.clearCalled, "The caches should have been cleared.")
    }
    
    func test_whenMakeKeywordsViewController_itShouldHaveTheCorrectPropertiesSet() {
        // Given
        let sceneDelegate = SceneDelegate()

        // When
        let sut = sceneDelegate.makeMusicListViewController()

        let musicListViewControllerMirror = Mirror(reflecting: sut)
        guard let viewModel = musicListViewControllerMirror.firstChild(of: MusicListViewModel.self) else {
            XCTFail("Could not find MusicListViewModel.")
            return
        }

        let viewModelMirror = Mirror(reflecting: viewModel)
        
        guard let fetchShuffledMusicListUseCase = viewModelMirror.firstChild(of: FetchShuffledMusicListUseCase.self)
        else {
            XCTFail("A `FetchShuffledMusicListUseCase` should have been provided.")
            return
        }
        let fetchShuffledMusicListUseCaseMirror = Mirror(reflecting: fetchShuffledMusicListUseCase)
        let artistLookupService = fetchShuffledMusicListUseCaseMirror.firstChild(of: ArtistLookupService.self)
        
        guard let imagesService = viewModelMirror.firstChild(of: ImagesService.self)
        else {
            XCTFail("An `ImagesService` should have been provided.")
            return
        }
        let imagesServiceMirror = Mirror(reflecting: imagesService)
        let cacheService = imagesServiceMirror.firstChild(of: CacheService.self)

        // Then
        XCTAssertNotNil(artistLookupService, "An `ArtistLookupService` should have been provided.")
        XCTAssertTrue(artistLookupService?.dispatcher is URLSessionDispatcher, "`artistLookupService.dispatcher` should be an URLSessionDispatcher.")
        XCTAssertTrue(imagesService.dispatcher is URLSessionDispatcher, "`imagesService.dispatcher` should be an URLSessionDispatcher.")
        XCTAssertNotNil(cacheService, "A `CacheService` should have been provided.")
        XCTAssertNotNil(viewModel.viewStateRenderer, "The `viewStateRenderer` should not be nil.")
        XCTAssertNotNil(viewModel.viewModelBinder, "The `viewModelBinder` should not be nil.")
    }
    
}

// MARK: - Testing Helpers

private final class CacheServiceProviderSpy: CacheServiceProvider {
    
    init() {}
    
    init(fileManager: FileManager, cacheDirectoryName: String) {}
    
    func save(data: Data, key: String, completion: ((Result<Void, CacheServiceError>) -> Void)?) {}
    
    func loadData(from key: String, completion: ((Result<Data, CacheServiceError>) -> Void)) {}
    
    private(set) var clearCalled = false
    func clear(completion: ((Result<Data, CacheServiceError>) -> Void)?) {
        clearCalled = true
    }
    
}
