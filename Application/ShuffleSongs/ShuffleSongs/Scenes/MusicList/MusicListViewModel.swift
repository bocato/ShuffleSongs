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
}

/// Defines the display logic for `MusicListViewController`
protocol MusicListDisplayLogic {
    
    /// Defines operations to be done on viewDidLoad, normally initializations and setups
    func onViewDidLoad()
    
    /// Returns the number of musics to be shown on the screen
    var numberOfMusicItems: Int { get }
    
    /// Get's the music item for some index
    ///
    /// - Parameter index: some index
    /// - Returns: nil, if the index does not exist, `MusicInfoItem` otherwise
    func musicListCellViewModel(at index: Int) -> MusicListTableViewCellViewModel
}

/// Defines the business logic for `MusicListViewController`
protocol MusicListBusinessLogic {
    /// Fetches a music list, shuffled
    func fetchMusicList()
}

// Defines an interface for the `MusicListViewModel`
protocol MusicListViewModelProtocol: MusicListDisplayLogic, MusicListBusinessLogic {}

final class MusicListViewModel: MusicListViewModelProtocol {
    
    // MARK: - Dependencies
    
    private let fetchShuffledMusicListUseCase: FetchShuffledMusicListUseCaseProvider
    private let musicListViewDataConverter: MusicListViewDataConverting
    private let imagesService: ImagesServiceProvider
    
    // MARK: - Binding
    
    weak var viewStateRenderer: ViewStateRendering?
    weak var viewModelBinder: MusicListViewModelBinding?
    
    // MARK: - Private Properties
    
    private var cellViewModels = [MusicListTableViewCellViewModel]()
    
    // MARK: - View Properties / Binding
    
    private var viewTitle: String? {
        didSet {
            viewModelBinder?.viewTitleDidChange(viewTitle)
        }
    }
    
    // MARK: - Initialization
    
    init(
        fetchShuffledMusicListUseCase: FetchShuffledMusicListUseCaseProvider,
        musicListViewDataConverter: MusicListViewDataConverting = MusicListViewDataConverter(),
        imagesService: ImagesServiceProvider
    ) {
        self.fetchShuffledMusicListUseCase = fetchShuffledMusicListUseCase
        self.musicListViewDataConverter = musicListViewDataConverter
        self.imagesService = imagesService
    }
    
}

// MARK: - Display Logic
extension MusicListViewModel: MusicListDisplayLogic {
    
    func onViewDidLoad() {
        viewTitle = "Shuffle Songs"
        fetchMusicList()
    }

    var numberOfMusicItems: Int {
        return cellViewModels.count
    }
    
    func musicListCellViewModel(at index: Int) -> MusicListTableViewCellViewModel {
        return cellViewModels[index]
    }
    
}


// MARK: - MusicListViewModelBusinessLogic
extension MusicListViewModel: MusicListBusinessLogic {
    
    func fetchMusicList() {
        fetchShuffledMusicListUseCase.execute { [weak self] event in
            switch event.status {
            case .loading:
                self?.viewStateRenderer?.render(.loading)
            case let .serviceError(error):
                self?.handleServiceError(error)
            case let .data(list):
                self?.handleShuffledList(list)
            default:
                return
            }
        }
    }
    
    // MARK: - FetchMusicList Handlers
    
    private func handleShuffledList(_ list: [MusicInfoItem]) {
        let viewDataItems = musicListViewDataConverter.convert(list)
        cellViewModels = viewDataItems.map {
            MusicListTableViewCellViewModel(
                dataModel: $0,
                imagesService: imagesService)
        }
        viewStateRenderer?.render(.content)
    }
    
    private func handleServiceError(_ error: Error) {
        let filler = ViewFiller(title: "Ooops!", subtitle: "Something wrong has happened")
        viewStateRenderer?.render(.error(withFiller: filler))
    }
    
}
