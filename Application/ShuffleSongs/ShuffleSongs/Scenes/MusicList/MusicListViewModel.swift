//
//  MusicListViewModel.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation
/// Defines a binding protocol between the viewModel and the ViewController
protocol MusicListViewModelBinding: AnyObject {
    
    // MARK: - Property Bindings
    func viewTitleDidChange(_ title: String?)
    
    // MARK: - Action Related Bindings
    
}

/// Defines the display logic for MusicListViewController
protocol MusicListDisplayLogic {
    
    /// Defines operations to be done on viewDidLoad, normally initializations and setups
    func onViewDidLoad()
    
    /// Returns the number of musics to be shown on the screen
    var numberOfMusicItems: Int { get }
    
    /// Get's the music item for some index
    ///
    /// - Parameter index: some index
    /// - Returns: nil, if the index does not exist, `MusicInfoItem` otherwise
    func musicInfoItemViewData(at index: Int) -> MusicListItemViewData
}

/// Defines the business logic for MusicListViewController
protocol MusicListBusinessLogic {
    
}
final class MusicListViewModel: MusicListDisplayLogic {
    
    // MARK: - Dependencies
    
    let fetchShuffledMusicListUseCase: FetchShuffledMusicListUseCaseProvider
    
    // MARK: - Binding
    
    weak var viewStateRenderer: ViewStateRendering?
    weak var viewModelBinder: MusicListViewModelBinding?
    
    // MARK: - Private Properties
    
    private var musicItems = [MusicListItemViewData]()
    
    // MARK: - Computed Properties
    
    // MARK: - View Properties / Binding
    
    private var viewTitle: String? {
        didSet {
            viewModelBinder?.viewTitleDidChange(viewTitle)
        }
    }
    
    // MARK: - Initialization
    
    init(fetchShuffledMusicListUseCase: FetchShuffledMusicListUseCaseProvider) {
        self.fetchShuffledMusicListUseCase = fetchShuffledMusicListUseCase
    }
    
    // MARK: - Display Logic
    
    func onViewDidLoad() {
        viewTitle = "Shuffle Songs"
    }
    
    var numberOfMusicItems: Int {
        return 0
    }
    
    func musicInfoItemViewData(at index: Int) -> MusicListItemViewData {
        return musicItems[index]
    }
    
}

// MARK: - MusicListViewModelBusinessLogic
extension MusicListViewModel: MusicListBusinessLogic {
    
}
