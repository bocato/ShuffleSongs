//
//  MusicListTableViewCell.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

final class MusicListTableViewCell: UITableViewCell {
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: nil)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Configuration
    
    /// Configures the cell with a viewData object of type `MusicInfoItem`
    func configure(with viewDataItem: MusicInfoItem) {
        
    }
    
    // MARK: - Setup
    
    private func setup() {
        backgroundColor = .darkPurple
        addSubViews()
    }
    
    // MARK: - Layout
    
    private func addSubViews() {
        constrainStackView()
    }
    
    private func constrainStackView() {
        
    }
    
}
