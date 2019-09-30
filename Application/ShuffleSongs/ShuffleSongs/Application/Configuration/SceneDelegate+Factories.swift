//
//  SceneDelegate+Factories.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit
import Networking
import Caching

// This could be done elsewere, but since it's a simple application, i'll put it here for now.
// Also, we could implement a more intricate system/strategy for dependency injection with containers or something else.
extension SceneDelegate: MusicListConfigurator {
    
    func makeMusicListViewController() -> MusicListViewController {
        
        let urlSessionDispatcher = URLSessionDispatcher()
        let artistLookupService = ArtistLookupService(dispatcher: urlSessionDispatcher)
        
        let fetchShuffledMusicListUseCase = FetchShuffledMusicListUseCase(artistLookupService: artistLookupService)
        
        let cacheService = MemoryCacheService()
        cache = cacheService
        
        let imagesService = ImagesService(
            dispatcher: urlSessionDispatcher,
            cacheService: cacheService
        )
        
        let viewModel = MusicListViewModel(
            fetchShuffledMusicListUseCase: fetchShuffledMusicListUseCase,
            imagesService: imagesService
        )
        
        let viewController = MusicListViewController(viewModel: viewModel)
        viewModel.viewStateRenderer = viewController
        viewModel.viewModelBinder = viewController
        
        return viewController
    }
    
}


