//
//  SceneDelegate.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        setupRootViewController(windowScene: windowScene)
    }
    
}
// MARK: - RootViewConfigurator
extension SceneDelegate: RootViewConfigurator {
    
    func setupRootViewController(windowScene: UIWindowScene) {
        let musicListViewController = makeMusicListViewController()
        let rootViewController = ShuffleSongsNavigationController(rootViewController: musicListViewController)
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
    
}
