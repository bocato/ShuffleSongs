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
    
}

// MARK: - Testing Helpers
private final class MusicListViewModelDummy: MusicListViewModelProtocol {
    func onViewDidLoad() {}
    var numberOfMusicItems: Int { return 1 }
    func musicListCellViewModel(at index: Int) -> MusicListTableViewCellViewModel { return .dummy }
    func fetchMusicList() {}
}

private final class ModalHelperDummy: ModalHelperProtocol {
    func showAlert(inController controller: UIViewController?, data: SimpleModalViewData, buttonActionHandler: (() -> Void)?, presentationCompletion: (() -> Void)?) {}
}

private final class MusicListViewModelSpy: MusicListViewModelProtocol {
    
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

private final class FetchShuffledMusicListUseCaseProviderDummy: FetchShuffledMusicListUseCaseProvider {
    func execute(completion: @escaping (UseCaseEvent<[MusicInfoItem], FetchShuffledMusicListUseCaseError>) -> Void) {}
}


private final class ModalHelperSpy: ModalHelperProtocol {
    
    private(set) var showAlertCalled = false
    private(set) var controllerPassed: UIViewController?
    private(set) var dataPassed: SimpleModalViewData?
    func showAlert(
        inController controller: UIViewController?,
        data: SimpleModalViewData,
        buttonActionHandler: (() -> Void)?,
        presentationCompletion: (() -> Void)?) {
        
    }
    
}
