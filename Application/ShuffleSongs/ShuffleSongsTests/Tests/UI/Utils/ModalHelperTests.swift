//
//  ModalHelperTests.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 29/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import ShuffleSongs
import UIKit

final class ModalHelperTests: XCTestCase {
    
    func test_showAlert_shouldPresentAnAlertOnController() {
        // Given
        let viewControllerSpy = UIViewControllerSpy()
        let data = SimpleModalViewData(title: "title", subtitle: "subtitle")
        let sut = ModalHelper()
        
        // When
        sut.showAlert(inController: viewControllerSpy, data: data)
        
        // Then
        XCTAssertTrue(viewControllerSpy.presentCalled)
        XCTAssertTrue(viewControllerSpy.viewControllerToPresentPassed is UIAlertController)
    }
    
}

private final class UIViewControllerSpy: UIViewController {
    
    private(set) var presentCalled = false
    private(set) var viewControllerToPresentPassed: UIViewController?
    private(set) var animatedFlagPassed: Bool?
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentCalled =  true
        viewControllerToPresentPassed = viewControllerToPresent
        animatedFlagPassed = flag
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
}
