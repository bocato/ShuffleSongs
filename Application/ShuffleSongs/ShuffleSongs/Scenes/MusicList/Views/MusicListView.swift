//
//  MusicListView.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

final class MusicListView: UIView {
   
    // MARK: UI
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.isHidden = true
        tableView.register(MusicListTableViewCell.self, forCellReuseIdentifier: MusicListTableViewCell.className)
        return tableView
    }()
    
    // MARK: - Initialization
    
    /// Initializes a MusicListView
    /// - Parameter tableViewDataSource: the inner tableView dataSource
    init(
        tableViewDataSource: UITableViewDataSource
    ) {
        super.init(frame: UIScreen.main.bounds)
        self.tableView.dataSource = tableViewDataSource
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setup() {
        backgroundColor = .black
        addSubViews()
    }
    
    // MARK: - Layout
    
    private func addSubViews() {
        constrainTableView()
    }
    
    private func constrainTableView() {
        addSubview(tableView)
        tableView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            bottomConstant: Metrics.Margin.default
        )
    }
    
    // MARK: Public Functions
    
    /// Reloads the tableView
    func reloadTableView() {
        tableView.reloadData()
    }
    
    /// Shows the tableView
    func showTableView(_ show: Bool = true) {
        tableView.isHidden = !show
    }
    
}
