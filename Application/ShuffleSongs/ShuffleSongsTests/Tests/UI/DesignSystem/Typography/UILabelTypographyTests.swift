//
//  UILabel+TypographyTests.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 28/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
import UIKit
@testable import ShuffleSongs

final class UILabelTypographyTests: XCTestCase {
    
    func test_cellTitle_typographyShouldBeAppliedCorrectly() {
        // Given
        let typographyToApply: Typography = .cellTitle
        let colorToApply: UIColor = .brown
        let label = UILabel()
        
        // When
        label.apply(typography: typographyToApply, with: colorToApply)
        
        // Then
        XCTAssertEqual(typographyToApply.font, label.font, "Expected \(typographyToApply.font), but got \(String(describing: label.font)).")
        XCTAssertEqual(colorToApply, label.textColor, "Expected \(colorToApply), but got \(String(describing: label.textColor)).")
    }
    
    func test_cellSubtitle_typographyShouldBeAppliedCorrectly() {
        // Given
        let typographyToApply: Typography = .cellSubtitle
        let colorToApply: UIColor = .brown
        let label = UILabel()
        
        // When
        label.apply(typography: typographyToApply, with: colorToApply)
        
        // Then
        XCTAssertEqual(typographyToApply.font, label.font, "Expected \(typographyToApply.font), but got \(String(describing: label.font)).")
        XCTAssertEqual(colorToApply, label.textColor, "Expected \(colorToApply), but got \(String(describing: label.textColor)).")
    }
    
}
