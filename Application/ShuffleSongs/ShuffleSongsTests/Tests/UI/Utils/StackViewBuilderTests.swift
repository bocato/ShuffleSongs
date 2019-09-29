//
//  StackViewBuilderTests.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 29/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import ShuffleSongs
import UIKit

final class StackViewBuilderTests: XCTestCase {
    
    func test_builder_shouldReturnExpectedStackView() {
        // Given
        let axis: NSLayoutConstraint.Axis = .horizontal
        let alignment: UIStackView.Alignment = .fill
        let spacing: CGFloat = 10.0
        let distribution: UIStackView.Distribution = .fillEqually
        let arrangedSubviews: [UIView] = [
            UIImageView(frame: .zero),
            UILabel(frame: .zero)
        ]
        
        // When
        let sut = StackViewBuilder {
            $0.axis = axis
            $0.alignment = alignment
            $0.spacing = spacing
            $0.distribution = distribution
            $0.arrangedSubviews = arrangedSubviews
        }.build()
        
        // Then
        XCTAssertEqual(axis, sut.axis, "Expected \(axis), but got \(sut.axis).")
        XCTAssertEqual(alignment, sut.alignment, "Expected \(alignment), but got \(sut.alignment).")
        XCTAssertEqual(spacing, sut.spacing, "Expected \(spacing), but got \(sut.spacing).")
        XCTAssertEqual(distribution, sut.distribution, "Expected \(distribution), but got \(sut.distribution).")
        XCTAssertEqual(arrangedSubviews, sut.arrangedSubviews, "Expected \(arrangedSubviews), but got \(sut.arrangedSubviews).")
    }
    
}
