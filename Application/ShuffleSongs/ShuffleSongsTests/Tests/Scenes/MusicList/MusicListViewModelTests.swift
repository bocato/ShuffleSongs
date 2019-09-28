//
//  MusicListViewModelTests.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 28/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import ShuffleSongs
import Networking

final class MusicListViewModelTests: XCTestCase {
    
    // MARK: - Display Logic Tests
    
    func test_onViewDidLoad_theTitleShouldBeSetAndFetchMusicListToBeCalled() {
        // Given
        let expectedTitle = "Shuffle Songs"
        let fetchShuffledMusicListUseCaseSpy = FetchShuffledMusicListUseCaseProviderSpy()
        let sut = MusicListViewModel(
            fetchShuffledMusicListUseCase: fetchShuffledMusicListUseCaseSpy,
            imagesService: ImagesServiceProviderDummy()
        )
        let viewModelBindingSpy = MusicListViewModelBindingSpy()
        sut.viewModelBinder = viewModelBindingSpy
        
        // When
        sut.onViewDidLoad()
        
        // Then
        XCTAssertTrue(viewModelBindingSpy.viewTitleDidChangeCalled, "`viewTitleDidChange` should have been called.")
        XCTAssertEqual(viewModelBindingSpy.titlePassedToViewTitleDidChange, expectedTitle, "Expected \(expectedTitle), but got \(viewModelBindingSpy.titlePassedToViewTitleDidChange.debugDescription)")
        XCTAssertTrue(fetchShuffledMusicListUseCaseSpy.executeCalled)
    }
    
    func test_numberOfMusicItems_shouldReturnZeroOnInit() {
        // Given / When
        let sut = MusicListViewModel(
            fetchShuffledMusicListUseCase: FetchShuffledMusicListUseCaseProviderSpy(),
            imagesService: ImagesServiceProviderDummy()
        )
        
        // Then
        XCTAssertEqual(sut.numberOfMusicItems, 0, "Expected 0, but got \(sut.numberOfMusicItems)")
    }
    
    func test_numberOfMusicItems_shouldReturnTheSameAmountOfItemsReturnedByFetchShuffledMusicListUseCase() {
        // Given
        let fetchShuffledMusicListUseCaseProviderStub = FetchShuffledMusicListUseCaseProviderStub()
        let musicItemsToReturn = [
            MusicInfoItem(artworkURL: nil, trackName: "track 1", artistName: "artist 1", primaryGenreName: "genre 1"),
            MusicInfoItem(artworkURL: nil, trackName: "track 2", artistName: "artist 2", primaryGenreName: "genre 2"),
            MusicInfoItem(artworkURL: nil, trackName: "track 3", artistName: "artist 3", primaryGenreName: "genre 3")
        ]
        fetchShuffledMusicListUseCaseProviderStub.resultsToReturn = [.data(musicItemsToReturn)]
        
        // When
        let sut = MusicListViewModel(
            fetchShuffledMusicListUseCase: fetchShuffledMusicListUseCaseProviderStub,
            imagesService: ImagesServiceProviderDummy()
        )
        sut.fetchMusicList()
        
        // Then
        XCTAssertEqual(sut.numberOfMusicItems, musicItemsToReturn.count, "Expected \(musicItemsToReturn.count), but got \(sut.numberOfMusicItems)")
    }
    
    func test_musicListCellViewModel_shouldReturnTheCorrectModelAtIndex() {
        // Given
        let fetchShuffledMusicListUseCaseProviderStub = FetchShuffledMusicListUseCaseProviderStub()
        let musicItemsToReturn = [
            MusicInfoItem(artworkURL: nil, trackName: "track 1", artistName: "artist 1", primaryGenreName: "genre 1")
        ]
        fetchShuffledMusicListUseCaseProviderStub.resultsToReturn = [.loading(), .data(musicItemsToReturn)]
        let sut = MusicListViewModel(
            fetchShuffledMusicListUseCase: fetchShuffledMusicListUseCaseProviderStub,
            imagesService: ImagesServiceProviderDummy()
        )
        sut.fetchMusicList()
        
        let expectedTitle = "track 1"
        let expectedSubtitle = "artist 1 (genre 1)"
        
        // When
        let viewModel = sut.musicListCellViewModel(at: 0)
        
        // Then
        XCTAssertEqual(viewModel.title, expectedTitle, "Expected \(expectedTitle), but got \(viewModel.title)")
        XCTAssertEqual(viewModel.subtitle, expectedSubtitle, "Expected \(expectedSubtitle), but got \(viewModel.subtitle)")
    }
    
    // MARK: - MusicListBusinessLogic Tests
    
    func test_fetchMusicList_shouldReturnServiceError() {
        // Given
        let fetchShuffledMusicListUseCaseProviderStub = FetchShuffledMusicListUseCaseProviderStub()
        let expectedError: NetworkingError = .unexpected
        fetchShuffledMusicListUseCaseProviderStub.resultsToReturn = [.loading(), .serviceError(expectedError)]
        let sut = MusicListViewModel(
            fetchShuffledMusicListUseCase: fetchShuffledMusicListUseCaseProviderStub,
            imagesService: ImagesServiceProviderDummy()
        )
        let viewStateRenderingSpy = ViewStateRenderingSpy()
        sut.viewStateRenderer = viewStateRenderingSpy
        
        // When
        sut.fetchMusicList()
        
        // Then
        let states = viewStateRenderingSpy.allStatesPassed
        guard case .loading = states[0] else {
            XCTFail("Expected .loading, but got \(states[0])")
            return
        }
        
        guard case .error = states[1] else {
            XCTFail("Expected .error, but got \(states[1])")
            return
        }
        XCTAssertEqual(sut.numberOfMusicItems, 0, "Expected 0, but got \(sut.numberOfMusicItems)")
    }
    
    func test_fetchMusicList_shouldReturnDataAndSetTheExpectedNumberOfViewModels() {
        // Given
        let fetchShuffledMusicListUseCaseProviderStub = FetchShuffledMusicListUseCaseProviderStub()
        let musicItemsToReturn = [
            MusicInfoItem(artworkURL: nil, trackName: "track 1", artistName: "artist 1", primaryGenreName: "genre 1"),
            MusicInfoItem(artworkURL: nil, trackName: "track 2", artistName: "artist 2", primaryGenreName: "genre 2"),
            MusicInfoItem(artworkURL: nil, trackName: "track 3", artistName: "artist 3", primaryGenreName: "genre 3")
        ]
        fetchShuffledMusicListUseCaseProviderStub.resultsToReturn = [.loading(), .data(musicItemsToReturn)]
        let sut = MusicListViewModel(
            fetchShuffledMusicListUseCase: fetchShuffledMusicListUseCaseProviderStub,
            imagesService: ImagesServiceProviderDummy()
        )
        let viewStateRenderingSpy = ViewStateRenderingSpy()
        sut.viewStateRenderer = viewStateRenderingSpy
        
        // When
        sut.fetchMusicList()
        
        // Then
        let states = viewStateRenderingSpy.allStatesPassed
        guard case .loading = states[0] else {
            XCTFail("Expected .loading, but got \(states[0])")
            return
        }
        
        guard case .content = states[1] else {
            XCTFail("Expected .loading, but got \(states[1])")
            return
        }
        XCTAssertEqual(sut.numberOfMusicItems, 3, "Expected 3, but got \(sut.numberOfMusicItems)")
    }
    
    func test_fetchMusicList_whenFetchShuffledMusicListUseCaseProviderSendsAnExpectedEvent_viewControllerShouldDoNothing() {
        // Given
        let fetchShuffledMusicListUseCaseProviderStub = FetchShuffledMusicListUseCaseProviderStub()
        fetchShuffledMusicListUseCaseProviderStub.resultsToReturn = [.idle()]
        let sut = MusicListViewModel(
            fetchShuffledMusicListUseCase: fetchShuffledMusicListUseCaseProviderStub,
            imagesService: ImagesServiceProviderDummy()
        )
        let viewStateRenderingSpy = ViewStateRenderingSpy()
        sut.viewStateRenderer = viewStateRenderingSpy
        
        // When
        sut.fetchMusicList()
        
        // Then
        let states = viewStateRenderingSpy.allStatesPassed
        XCTAssertEqual(states.count, 0, "Expected 0, but got \(states.count)")
    }

}

// MARK: - Testing Helpers

private final class FetchShuffledMusicListUseCaseProviderSpy: FetchShuffledMusicListUseCaseProvider {
    private(set) var executeCalled = false
    func execute(completion: @escaping (UseCaseEvent<[MusicInfoItem], FetchShuffledMusicListUseCaseError>) -> Void) {
        executeCalled = true
    }
}

final class ImagesServiceProviderDummy: ImagesServiceProvider {
    func getImageDataFromURL(_ urlString: String, completion: @escaping (Result<Data, ImagesServiceError>) -> Void) -> URLRequestToken? { return nil }
}

private final class MusicListViewModelBindingSpy: MusicListViewModelBinding {
    
    private(set) var viewTitleDidChangeCalled = false
    private(set) var titlePassedToViewTitleDidChange: String?
    private(set) var viewTitleDidChangeValuesAcumulated = [String?]()
    func viewTitleDidChange(_ title: String?) {
        viewTitleDidChangeCalled = true
        titlePassedToViewTitleDidChange = title
        viewTitleDidChangeValuesAcumulated.append(title)
    }
    
}

private final class ViewStateRenderingSpy: ViewStateRendering {
    
    private(set) var renderStateCalled = false
    private(set) var lastStatePassed: ViewState?
    private(set) var allStatesPassed = [ViewState]()
    func render(_ state: ViewState) {
        renderStateCalled = true
        lastStatePassed = state
        allStatesPassed.append(state)
    }
    
}

private final class FetchShuffledMusicListUseCaseProviderStub: FetchShuffledMusicListUseCaseProvider {
    var resultsToReturn = [UseCaseEvent<[MusicInfoItem], FetchShuffledMusicListUseCaseError>]()
    func execute(completion: @escaping (UseCaseEvent<[MusicInfoItem], FetchShuffledMusicListUseCaseError>) -> Void) {
        resultsToReturn.forEach {
            completion($0)
        }
    }
}
