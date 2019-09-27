//
//  StackViewBuilder.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

// Helper class simplify building StackViews
final class StackViewBuilder {
    
    var axis: NSLayoutConstraint.Axis = .vertical
    var alignment: UIStackView.Alignment = .fill
    var spacing: CGFloat = 0.0
    var distribution: UIStackView.Distribution = .fillProportionally
    var arrangedSubviews: [UIView] = []
    
    typealias BuilderClosure = (StackViewBuilder) -> Void
    
    init(buildClosure: BuilderClosure) {
        buildClosure(self)
    }
    
    func build() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.spacing = spacing
        stackView.distribution = distribution
        return stackView
    }
}
