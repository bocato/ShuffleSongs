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
        XCTAssertTrue(cacheServiceProviderSpy.clearCalled, "The caches should have been cleaned.")
    }
    
    func test_whenMakeKeywordsViewController_itShouldHaveTheCorrectPropertiesSet() {
        // Given
        let sceneDelegate = SceneDelegate()

        // When
        let sut = sceneDelegate.makeMusicListViewController()

        // -> KeywordsViewController Dependencies <-
        let musicListViewControllerMirror = Mirror(reflecting: sut)
        guard let viewModel = musicListViewControllerMirror.firstChild(of: MusicListViewModel.self) else {
            XCTFail("Could not find MusicListViewModel.")
            return
        }

        // -> KeywordsViewModel Dependencies <-
        let viewModelMirror = Mirror(reflecting: viewModel)
        
        let fetchShuffledMusicListUseCase = viewModelMirror.firstChild(of: FetchShuffledMusicListUseCase.self)
        let imagesService = viewModelMirror.firstChild(of: ImagesService.self)

        // Then
        XCTAssertNotNil(fetchShuffledMusicListUseCase, "A `FetchShuffledMusicListUseCase` should have been provided.")
        XCTAssertNotNil(imagesService, "An `ImagesService` should have been provided.")
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
