//
//  MusicListTableViewCellSnapshotTests.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 29/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import ShuffleSongs

final class MusicListTableViewCellSnapshotTests: FBSnapshotTestCase {
    
    // MARK: - Tests
    
    func test_cell_shouldPresentCorrectLayoutWhenLoading() {
        recordMode = false
        deviceSizes.forEach { (device, size) in
            // Given
            let dataModel = MusicListItemViewData(
                imageURL: nil,
                title: "title",
                subtitle: "subtitle"
            )
            guard let viewModel = buildViewModel(dataModel: dataModel) else {
                XCTFail("Could not create viewModel.")
                return
            }
            let sut = buildSut()
            
            // When
            configureView(sut, size: size, viewModel: viewModel)
            
            // Then
            let snapshotName = "music_list_table_view_cell_loading_\(device)"
            FBSnapshotVerifyView(sut, identifier: snapshotName, overallTolerance: 0.01)
        }
    }
    
    func test_cell_shouldPresentValidInformationWhenLoaded() {
        recordMode = false
        deviceSizes.forEach { (device, size) in
            // Given
            let dataModel = MusicListItemViewData(
                imageURL: nil,
                title: "title",
                subtitle: "subtitle"
            )
            guard let viewModel = buildViewModel(dataModel: dataModel) else {
                XCTFail("Could not create viewModel.")
                return
            }
            let sut = buildSut()
            
            // When
            configureView(sut,size: size, viewModel: viewModel)
            sut.hideLoading()
            let loadingViewWasRemovedExpectation = expectation(description: "loadingViewWasRemovedExpectation")
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.26) {
                loadingViewWasRemovedExpectation.fulfill()
            }
            wait(for: [loadingViewWasRemovedExpectation], timeout: 0.5)
            
            // Then
            let snapshotName = "music_list_table_view_cell_configured_\(device)"
            FBSnapshotVerifyView(sut, identifier: snapshotName, overallTolerance: 0.01)
        }
    }
    
    // MARK: - Helpers
    
    private func buildSut() -> MusicListTableViewCell {
        let sut = MusicListTableViewCell()
        sut.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        sut.backgroundColor = .darkPurple
        return sut
    }
    
    private func buildViewModel(dataModel: MusicListItemViewData) -> MusicListTableViewCellViewModel? {
        guard let expectedImageData = UIImage.logo.pngData() else {
            XCTFail("Could not create `expectedImageData`")
            return nil
        }
        let imagesServiceProviderStub = ImagesServiceProviderStub(resultToReturn: .success(expectedImageData))
        return .init(dataModel: dataModel, imagesService: imagesServiceProviderStub)
    }
    
    private func configureView(_ sut: MusicListTableViewCell, size: CGSize, viewModel: MusicListTableViewCellViewModel) {
        sut.frame.size.width = size.width
        sut.configure(with: viewModel)
        sut.layoutIfNeeded()
    }
    
}
