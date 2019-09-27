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
    
    // MARK: - Properties
    
    let viewModel: MusicListViewModelProtocol
    let modalHelper: ModalHelperProtocol
    
    // MARK: - Initialization
    
    init(
        viewModel: MusicListViewModelProtocol,
        modalHelper: ModalHelperProtocol = ModalHelper()
    ) {
        self.viewModel = viewModel
        self.modalHelper = modalHelper
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
    }
    
    // MARK: - Setup
    
    private func setupCustomView () {
        view = CustomView(
            tableViewDataSource: self
        )
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
        switch state {
        case .loading:
            showLoading()
        case .content:
            hideLoading()
            DispatchQueue.main.async {
                self.customView.reloadTableView()
                self.customView.showTableView()
            }
        case let .error(filler):
            hideLoading()
            renderError(filler)
        default:
            return
        }
        
    }
    
    private func renderError(_ filler: ViewFiller?) {
        guard let title = filler?.title, let subtitle = filler?.subtitle else { return }
        let data = SimpleModalViewData(title: title, subtitle: subtitle)
        showErrorModal(data)
    }
    
}

// MARK: - MusicListViewModelBinding
extension MusicListViewController: MusicListViewModelBinding {
    
    func showErrorModalWithData(_ modalData: SimpleModalViewData) {
        showErrorModal(modalData)
    }
    
    func viewTitleDidChange(_ title: String?) {
        DispatchQueue.main.async {
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
