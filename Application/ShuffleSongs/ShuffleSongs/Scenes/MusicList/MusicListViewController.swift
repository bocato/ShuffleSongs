//
//  MusicListViewController.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

final class MusicListViewController: UIViewController, CustomViewController {
    
    // MARK: - Aliases
    
    typealias CustomView = MusicListView
    
    // MARK: - UI
    private lazy var shuffleButton: UIBarButtonItem = {
        return UIBarButtonItem(
            image: .shuffle,
            style: .plain,
            target: self,
            action: #selector(shuffleButtonDidReceiveTouchUpInside)
        )
    }()
    
    // MARK: - Properties
    
    private let viewModel: MusicListViewModelProtocol
    private let modalHelper: ModalHelperProtocol
    private let mainQueue: Dispatching
    
    // MARK: - Initialization
    
    init(
        viewModel: MusicListViewModelProtocol,
        modalHelper: ModalHelperProtocol = ModalHelper(),
        mainQueue: Dispatching = AsyncQueue.main
    ) {
        self.viewModel = viewModel
        self.modalHelper = modalHelper
        self.mainQueue = mainQueue
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
    }
    
    override func loadView() {
        setupCustomView()
        setupShuffleButton()
    }
    
    // MARK: - Setup
    
    private func setupCustomView () {
        view = CustomView(
            tableViewDataSource: self
        )
    }
    
    private func setupShuffleButton() {
        navigationItem.rightBarButtonItem = shuffleButton
    }
    
    // MARK: - Actions
    
    @objc private func shuffleButtonDidReceiveTouchUpInside() {
        viewModel.fetchMusicList()
    }
    
    // MARK: - Helpers
    private func showErrorModal(_ data: SimpleModalViewData) {
        modalHelper.showAlert(
            inController: self,
            data: data,
            buttonActionHandler: nil,
            presentationCompletion: nil
        )
    }

}

// MARK: - ViewStateRendering
extension MusicListViewController: ViewStateRendering, LoadingPresenting {
    
    func render(_ state: ViewState) {
        mainQueue.dispatch {
            switch state {
            case .loading:
                self.handleLoading()
            case .content:
                self.handleContent()
            case let .error(filler):
                self.handleError(with: filler)
            default:
                return
            }
        }
    }
    
    private func handleLoading() {
        showLoading()
        shuffleButton.isEnabled = false
    }
    
    private func handleContent() {
        hideLoading()
        customView.reloadTableView()
        customView.showTableView()
        shuffleButton.isEnabled = true
    }
    
    private func handleError(with filler: ViewFiller?) {
        hideLoading()
        renderError(filler)
        shuffleButton.isEnabled = true
    }
    
    private func renderError(_ filler: ViewFiller?) {
        let title = filler?.title ?? "Unknown error!"
        let data = SimpleModalViewData(title: title, subtitle: filler?.subtitle)
        showErrorModal(data)
    }
    
}

// MARK: - MusicListViewModelBinding
extension MusicListViewController: MusicListViewModelBinding {
    
    func viewTitleDidChange(_ title: String?) {
        mainQueue.dispatch {
            self.title = title
        }
    }
    
}

extension MusicListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMusicItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: MusicListTableViewCell.self, for: indexPath)
        let cellViewModel = viewModel.musicListCellViewModel(at: indexPath.row)
        cell.configure(with: cellViewModel)
        return cell
    }

}
