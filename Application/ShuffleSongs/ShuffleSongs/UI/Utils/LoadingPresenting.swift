//
//  LoadingPresentable.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

protocol LoadingPresenting {
    /// Shows a loading view on top of some ViewControler
    func showLoading()
    /// Tries to hide the loadingView that is visible
    func hideLoading()
}
extension LoadingPresenting where Self: UIViewController {

    /// Shows a loading view on top of some ViewControler
    func showLoading() {
        let loadingView = LoadingView(frame: view.frame)
        loadingView.activityIndicatorStyle = .large
        view.addSubview(loadingView)
        loadingView.startAnimating()
    }
    
    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            let loadingView = self?.view.viewWithTag(LoadingView.tag)
            UIView.animate(withDuration: 0.25, animations: {
                loadingView?.alpha = 0
            }, completion: { completed in
                if completed {
                    (loadingView as? LoadingView)?.stopAnimating()
                    loadingView?.removeFromSuperview()
                }
            })
        }
    }

}
