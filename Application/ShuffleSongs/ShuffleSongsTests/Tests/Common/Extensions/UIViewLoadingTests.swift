//
//  UIView+LoadingTests.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 28/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit
import XCTest
@testable import ShuffleSongs

final class UIViewLoadingTests: XCTestCase {
    
    func test_showLoading() {
        // Given
        let view = UIView()
        
        // When
        view.showLoading()
        
        // Then
        XCTAssertNotNil(view.viewWithTag(LoadingView.tag), "The view should contain a `LoadingView`.")
    }
    
    func test_hideLoading() {
        // Given
        let view = UIView()
        view.showLoading()
        let theViewHadALoadingView = view.viewWithTag(LoadingView.tag) != nil
        
        // When
        view.hideLoading()
        let loadingViewWasRemovedExpectation = expectation(description: "loadingViewWasRemovedExpectation")
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.26) {
            loadingViewWasRemovedExpectation.fulfill()
        }
        wait(for: [loadingViewWasRemovedExpectation], timeout: 0.5)
        
        // Then
        XCTAssertTrue(theViewHadALoadingView, "The view had a `LoadingView` that needed to be hidden.")
        XCTAssertNil(view.viewWithTag(LoadingView.tag), "The view should not contain a `LoadingView`.")
    }
    
}
