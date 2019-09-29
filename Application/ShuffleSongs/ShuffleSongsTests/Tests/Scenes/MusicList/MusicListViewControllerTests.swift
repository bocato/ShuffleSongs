//
//  MusicListViewControllerTests.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 29/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import ShuffleSongs

final class MusicListViewControllerTests: XCTestCase {
    
    // MARK: - Properties

    private var viewControllerTestingLoader: ViewControllerTestingLoader<MusicListViewController>?

    // MARK: - Lifecycle

    override func tearDown() {
        viewControllerTestingLoader?.tearDown()
        viewControllerTestingLoader = nil
        super.tearDown()
    }

    private func buildSut(
        viewModel: MusicListViewModelProtocol = MusicListViewModelDummy(),
        modalHelper: ModalHelperProtocol = ModalHelperDummy()
    ) -> MusicListViewController {
        let controller = MusicListViewController(
            viewModel: viewModel,
            modalHelper: modalHelper)
        viewControllerTestingLoader = ViewControllerTestingLoader<MusicListViewController>()
        viewControllerTestingLoader?.setup(withViewController: controller)
        return controller
    }
    
    // MARK: - Tests
    
    func test_customView_shouldBeMusicListView() {
        // Given
        let sut = MusicListViewController(
            viewModel: MusicListViewModelDummy(),
            modalHelper: ModalHelperDummy()
        )
        
        // When
        sut.loadView()
        
        // Then
        XCTAssertTrue(sut.view is MusicListView)
    }
    
    func test_shuffleButton_shouldBeConfigured() {
        // Given
        let sut = MusicListViewController(
            viewModel: MusicListViewModelDummy(),
            modalHelper: ModalHelperDummy()
        )
        
        // When
        sut.loadView()
        
        // Then
        let shuffleButton = sut.navigationItem.rightBarButtonItem
        XCTAssertNotNil(shuffleButton, "The `rightBarButtonItem` should have been set.")
        XCTAssertEqual(shuffleButton?.image, UIImage.shuffle, "`shuffleButton` image should be the `shuffle` asset.")
    }
    
    func test_viewDidLoad_shouldTriggerViewModel_onViewDidLoad() {
        // Given
        let viewModelSpy = MusicListViewModelSpy()
        let sut = MusicListViewController(
            viewModel: viewModelSpy,
            modalHelper: ModalHelperDummy()
        )
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertTrue(viewModelSpy.onViewDidLoadCalled, "`onViewDidLoad` should have been called.")
    }
    
    func test_shuffleButtonTouchUpInside_shouldTriggerFetchMusicList() {
        // Given
        let viewModelSpy = MusicListViewModelSpy()
        let sut = MusicListViewController(
            viewModel: viewModelSpy,
            modalHelper: ModalHelperDummy()
        )
        sut.loadView()
        guard let shuffleButton = sut.navigationItem.rightBarButtonItem else {
            XCTFail("Could not find `shuffleButton`.")
            return
        }
        
        // When
        _ = shuffleButton.target?.perform(shuffleButton.action, with: nil)
        
        // Then
        XCTAssertTrue(viewModelSpy.fetchMusicListCalled, "`fetchMusicList` should have been called.")
    }
    
    func test_tableView_returnsTheCorrectCell() {
        // Given
        let sut = buildSut()
        guard let view = sut.view, let tableView = Mirror(reflecting: view).firstChild(of: UITableView.self) else {
            XCTFail("Could not find sut's tableView.")
            return
        }
        let indexPath = IndexPath(row: 0, section: 0)

        // When
        let tableViewCell = sut.tableView(tableView, cellForRowAt: indexPath)

        // Then
        XCTAssertTrue(tableViewCell is MusicListTableViewCell)
    }
    
    func test_tableView_returnsTheCorrectNumberOfRows() {
        // Given
        let sut = buildSut()
        guard let view = sut.view, let tableView = Mirror(reflecting: view).firstChild(of: UITableView.self) else {
            XCTFail("Could not find sut's tableView.")
            return
        }

        // When
        let numberOfRows = sut.tableView(tableView, numberOfRowsInSection: 0)

        // Then
        XCTAssertEqual(numberOfRows, 1, "Expected 1, but got \(numberOfRows).")
    }
    
    func test_render_loading_shuffleShouldBeDisabledAndLoadingShouldAppear() {
        // Given
        let sut = MusicListViewController(
            viewModel: MusicListViewModelDummy(),
            modalHelper: ModalHelperDummy(),
            mainQueue: SyncQueue.stubbedMain
        )
        sut.loadView()
        
        // When
        sut.render(.loading)
        
        // Then
        guard let shuffleButton = sut.navigationItem.rightBarButtonItem else {
            XCTFail("Could not find `shuffleButton`.")
            return
        }
        XCTAssertNotNil(sut.view.viewWithTag(LoadingView.tag), "A `LoadingView` should be appearing.")
        XCTAssertFalse(shuffleButton.isEnabled, "`shuffleButton` should have been disabled.")
    }
    
    
    func test_render_content_shuffleShouldBeEnabledAndLoadingShouldAppear() {
        // Given
        let sut = MusicListViewController(
            viewModel: MusicListViewModelDummy(),
            modalHelper: ModalHelperDummy(),
            mainQueue: SyncQueue.stubbedMain
        )
        sut.loadView()

        // When
        sut.render(.content)

        // Then
        guard let shuffleButton = sut.navigationItem.rightBarButtonItem else {
            XCTFail("Could not find `shuffleButton`.")
            return
        }
        XCTAssertNil(sut.view.viewWithTag(LoadingView.tag), "A `LoadingView` should not be appearing.")
        XCTAssertTrue(shuffleButton.isEnabled, "`shuffleButton` should not be disabled.")
    }
    
    func test_render_errorWithFiller_shuffleShouldBeEnabled_loadingShouldAppear_andErrorModalShouldBeShown() {
        // Given
        let modalHelperSpy = ModalHelperSpy()
        let sut = MusicListViewController(
            viewModel: MusicListViewModelDummy(),
            modalHelper: modalHelperSpy,
            mainQueue: SyncQueue.stubbedMain
        )
        sut.loadView()
        let expectedAlertTitle = "Error!"
        let filler = ViewFiller(title: expectedAlertTitle)

        // When
        sut.render(.error(withFiller: filler))

        // Then
        guard let shuffleButton = sut.navigationItem.rightBarButtonItem else {
            XCTFail("Could not find `shuffleButton`.")
            return
        }
        XCTAssertNil(sut.view.viewWithTag(LoadingView.tag), "A `LoadingView` should not be appearing.")
        XCTAssertTrue(modalHelperSpy.showAlertCalled, "An alert should have been shown.")
        XCTAssertEqual(expectedAlertTitle, modalHelperSpy.dataPassed?.title, "Expected \(expectedAlertTitle), but got \(modalHelperSpy.dataPassed?.title ?? "nil").")
        XCTAssertTrue(shuffleButton.isEnabled, "`shuffleButton` should not be disabled.")
    }
    
    func test_render_errorWithNoFiller_shuffleShouldBeEnabled_loadingShouldAppear_andErrorModalShouldBeShown() {
        // Given
        let modalHelperSpy = ModalHelperSpy()
        let sut = MusicListViewController(
            viewModel: MusicListViewModelDummy(),
            modalHelper: modalHelperSpy,
            mainQueue: SyncQueue.stubbedMain
        )
        sut.loadView()
        let expectedAlertTitle = "Unknown error!"

        // When
        sut.render(.error(withFiller: nil))

        // Then
        guard let shuffleButton = sut.navigationItem.rightBarButtonItem else {
            XCTFail("Could not find `shuffleButton`.")
            return
        }
        XCTAssertNil(sut.view.viewWithTag(LoadingView.tag), "A `LoadingView` should not be appearing.")
        XCTAssertTrue(modalHelperSpy.showAlertCalled, "An alert should have been shown.")
        XCTAssertEqual(expectedAlertTitle, modalHelperSpy.dataPassed?.title, "Expected \(expectedAlertTitle), but got \(modalHelperSpy.dataPassed?.title ?? "nil").")
        XCTAssertTrue(shuffleButton.isEnabled, "`shuffleButton` should not be disabled.")
    }
    
}

// MARK: - Testing Helpers
final class MusicListViewModelDummy: MusicListViewModelProtocol {
    func onViewDidLoad() {}
    var numberOfMusicItems: Int { return 1 }
    func musicListCellViewModel(at index: Int) -> MusicListTableViewCellViewModel { return .dummy }
    func fetchMusicList() {}
}

final class ModalHelperDummy: ModalHelperProtocol {
    func showAlert(inController controller: UIViewController?, data: SimpleModalViewData, buttonActionHandler: (() -> Void)?, presentationCompletion: (() -> Void)?) {}
}

final class MusicListViewModelSpy: MusicListViewModelProtocol {
    
    // MARK: - MusicListDisplayLogic
    private(set) var onViewDidLoadCalled = false
    func onViewDidLoad() {
        onViewDidLoadCalled = true
    }
    
    private(set) var numberOfMusicItemsCalled = false
    var numberOfMusicItems: Int {
        numberOfMusicItemsCalled = true
        return 0
    }
    
    private(set) var musicListCellViewModelCalled = false
    private(set) var indexPassed: Int?
    func musicListCellViewModel(at index: Int) -> MusicListTableViewCellViewModel {
        musicListCellViewModelCalled = true
        indexPassed = index
        return .dummy
    }
    
    // MARK: - MusicListBusinessLogic
    
    private(set) var fetchMusicListCalled = false
    func fetchMusicList() {
        fetchMusicListCalled = true
    }
    
}

final class FetchShuffledMusicListUseCaseProviderDummy: FetchShuffledMusicListUseCaseProvider {
    func execute(completion: @escaping (UseCaseEvent<[MusicInfoItem], FetchShuffledMusicListUseCaseError>) -> Void) {}
}

final class ModalHelperSpy: ModalHelperProtocol {
    
    private(set) var showAlertCalled = false
    private(set) var controllerPassed: UIViewController?
    private(set) var dataPassed: SimpleModalViewData?
    func showAlert(
        inController controller: UIViewController?,
        data: SimpleModalViewData,
        buttonActionHandler: (() -> Void)?,
        presentationCompletion: (() -> Void)?) {
        showAlertCalled = true
        controllerPassed = controller
        dataPassed = data
    }
    
}

extension SyncQueue {
    static let stubbedMain: SyncQueue = SyncQueue(queue: DispatchQueue(label: "stubbed-main-queue"))
}
