//
//  ShuffleSongsNavigationControllerSnapshotTests.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 29/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
import UIKit
@testable import ShuffleSongs

final class ShuffleSongsNavigationControllerSnapshotTests: XCTestCase {
    
    // MARK: - Tests
    
    func test_navigationBar_layoutShouldBeConfiguredAsExpected() {
        // Given
        let sut = ShuffleSongsNavigationController()
        let barStyle: UIBarStyle = .default
        let isTranslucent = true
        let tintColor: UIColor = .white
        let barTintColor: UIColor = .darkPurple
        let textTitleAttributtesForegroundColor: UIColor = .white
        
        // When
        sut.viewDidLoad()
        
        // Then
        let navigationBar = sut.navigationBar
        XCTAssertEqual(barStyle, navigationBar.barStyle, "Expected \(barStyle), but got \(navigationBar.barStyle).")
        XCTAssertEqual(isTranslucent, navigationBar.isTranslucent, "Expected \(isTranslucent), but got \(navigationBar.isTranslucent).")
        XCTAssertEqual(tintColor, navigationBar.tintColor, "Expected \(tintColor), but got \(String(describing: navigationBar.tintColor)).")
        XCTAssertEqual(barTintColor, navigationBar.barTintColor, "Expected \(barTintColor), but got \(String(describing: navigationBar.barTintColor)).")
        let sutTextTitleAttributtesForegroundColor = navigationBar.titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor
        XCTAssertEqual(textTitleAttributtesForegroundColor, sutTextTitleAttributtesForegroundColor, "Expected \(textTitleAttributtesForegroundColor), but got \(String(describing: sutTextTitleAttributtesForegroundColor)).")
    }
    
}
