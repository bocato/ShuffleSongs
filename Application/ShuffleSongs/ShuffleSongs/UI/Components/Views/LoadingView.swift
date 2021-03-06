//
//  LoadingView.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

/// Defines a simple loadingView for the project
final class LoadingView: UIView {
    
    // MARK: - Constants
    
    static let tag = 11111
    
    // MARK: - UI
    
    private lazy var blurView: UIView = {
        let view = UIView(frame: frame)
        view.backgroundColor = .black
        view.alpha = 0.25
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        return view
    }()
    
    // MARK: - Properties
    
    /// Exposes the `ActivityIndicator.Style`
    var activityIndicatorStyle: UIActivityIndicatorView.Style {
        set { activityIndicator.style = newValue }
        get { return activityIndicator.style }
    }
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        tag = LoadingView.tag
        addSubviews()
    }
    
    // MARK: - Layout
    
    private func addSubviews() {
        constrainBlurView()
        constrainActivityIndicator()
    }
    
    private func constrainBlurView() {
        addSubview(blurView)
        blurView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }
    
    private func constrainActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.anchorCenterSuperview()
        activityIndicator.heightAnchor.constraint(
            equalTo: widthAnchor,
            multiplier: 0.2
        ).isActive = true
        activityIndicator.widthAnchor.constraint(
            equalTo: activityIndicator.heightAnchor,
            constant: 1.0
        ).isActive = true
    }
    
    // MARK: - Public Functions

    /// Starts the loading animation
    public func startAnimating() {
        activityIndicator.startAnimating()
    }

    /// Stops the loading animation
    public func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
}
