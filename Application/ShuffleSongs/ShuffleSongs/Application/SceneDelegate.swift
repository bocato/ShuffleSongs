//
//  SceneDelegate.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit
import Caching

final class SceneDelegate: UIResponder, UIWindowSceneDelegate, CacheHolding {

    var window: UIWindow?
    var cache: CacheServiceProvider?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        setupRootViewController(windowScene: windowScene)
    }
    
}
// MARK: - RootViewConfigurator
extension SceneDelegate: RootViewConfigurator {
    
    func setupRootViewController(windowScene: UIWindowScene?) {
        
        resetCaches()
        
        let musicListViewController = makeMusicListViewController()
        let rootViewController = ShuffleSongsNavigationController(rootViewController: musicListViewController)
        let frame = windowScene?.coordinateSpace.bounds ?? UIScreen.main.bounds
        window = UIWindow(frame: frame)
        window?.windowScene = windowScene
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
    }
    
}
