//
//  ViewControllerTestingLoader.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 29/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit
import XCTest

/// Loads a ViewController to be tested
final class ViewControllerTestingLoader<T: UIViewController> {
    // MARK: - Private Properties

    // swiftlint:disable implicitly_unwrapped_optional
    private var rootWindow: UIWindow!

    // MARK: - Public Functions

    /// Sets up a viewController to be loader
    ///
    /// - Parameter viewController: the controller to be loaded
    func setup(withViewController viewController: T) {
        rootWindow = UIWindow(frame: UIScreen.main.bounds)
        rootWindow.isHidden = false
        rootWindow.rootViewController = viewController
        _ = viewController.view
        viewController.viewWillAppear(false)
        viewController.viewDidAppear(false)
    }

    /// Removes the controller from the window hierachy
    func tearDown() {
        guard let rootWindow = rootWindow,
            let rootViewController = rootWindow.rootViewController as? T else {
            XCTFail("tearDown() was called without setup() being called first")
            return
        }
        rootViewController.viewWillDisappear(false)
        rootViewController.viewDidDisappear(false)
        rootWindow.rootViewController = nil
        rootWindow.isHidden = true
        self.rootWindow = nil
    }

    /*********************/
    /****** EXAMPLE ******/
    /*********************/

//    final class MyTest: XCTestCase {
//
//        private var sut: MyController!
//        private var viewControllerTestingLoader: ViewControllerTestingLoader<MyController>!
//
//        override func setUp() {
//            super.setUp()
//            let controller = MyController()
//            sut = controller
//            viewControllerTestingLoader = ViewControllerTestingLoader<MyController>()
//            viewControllerTestingLoader.setup(withViewController: sut)
//        }
//
//        override func tearDown() {
//            sut = nil
//            viewControllerTestingLoader.tearDown()
//            viewControllerTestingLoader = nil
//            super.tearDown()
//        }
//
//    }
     
}
