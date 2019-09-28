//
//  UIView+Loading.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 28/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

extension UIView {

    /// Shows a loading view on top of some View
    func showLoading(activityIndicatorStyle: UIActivityIndicatorView.Style = .medium) {
        viewWithTag(LoadingView.tag)?.removeFromSuperview() // ensure that we have no other loadingView here
        let loadingView = LoadingView(frame: frame)
        loadingView.activityIndicatorStyle = activityIndicatorStyle
        addSubview(loadingView)
        loadingView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
        loadingView.startAnimating()
    }
    
    /// Tries to hide the loadingView that is visible
    func hideLoading() {
        let loadingView = viewWithTag(LoadingView.tag)
        UIView.animate(withDuration: 0.25, animations: {
            loadingView?.alpha = 0
        }, completion: { _ in
            (loadingView as? LoadingView)?.stopAnimating()
            loadingView?.removeFromSuperview()
        })
    }

}
