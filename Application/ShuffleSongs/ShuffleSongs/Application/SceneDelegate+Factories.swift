//
//  SceneDelegate+Factories.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit
import Networking

// This could be done elsewere, but since it's a simple application, i'll put it here for now.
// Also, we could implement a more intricate system/strategy for dependency injection with containers or something else.
extension SceneDelegate: MusicListConfigurator {
    
    func makeMusicListViewController() -> MusicListViewController {
        
        let urlSessionDispatcher = URLSessionDispatcher()
        let artistLookupService = ArtistLookupService(dispatcher: urlSessionDispatcher)
        
        let fetchShuffledMusicListUseCase = FetchShuffledMusicListUseCase(artistLookupService: artistLookupService)
        
        let viewModel = MusicListViewModel(fetchShuffledMusicListUseCase: fetchShuffledMusicListUseCase)
        
        let viewController = MusicListViewController(viewModel: viewModel)
        viewModel.viewStateRenderer = viewController
        viewModel.viewModelBinder = viewController
        
        return viewController
    }
    
}


