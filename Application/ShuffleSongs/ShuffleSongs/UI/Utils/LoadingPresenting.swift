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
        view.showLoading(activityIndicatorStyle: .large)
    }
    
    /// Tries to hide the loadingView that is visible
    func hideLoading() {
        view.hideLoading()
    }

}
