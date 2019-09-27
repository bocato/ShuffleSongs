//
//  MusicListTableViewCell.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

final class MusicListTableViewCell: UITableViewCell {
    
    // MARK: - Constants
    
    private let imageViewSide: CGFloat = 72
    
    // MARK: - UI
    
    private lazy var artworkImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.lineBreakMode = .byClipping
        label.apply(typography: .cellTitle, with: .reddish)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.lineBreakMode = .byClipping
        label.apply(typography: .cellSubtitle, with: .white)
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        return StackViewBuilder {
            $0.arrangedSubviews = [
                titleLabel,
                subtitleLabel
            ]
            $0.spacing = Metrics.Margin.tiny
            $0.axis = .vertical
            $0.distribution = .fill
        }.build()
    }()
    
    // MARK: - Dependencies
    
    private var viewModel: MusicListTableViewCellViewModelProtocol?
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.cancelImageRequest()
    }
    
    // MARK: - Configuration
    
    /// Configures the cell with a viewData object of type `MusicInfoItem`
    func configure(with viewModel: MusicListTableViewCellViewModelProtocol) {
        self.viewModel = viewModel
        setupViewData()
    }
    
    // MARK: - Setup
    
    private func setupLayout() {
        backgroundColor = .darkPurple
        addSubViews()
    }
    
    private func setupViewData() {
        fetchImage()
        setupLabels()
    }
    
    private func fetchImage() {
        viewModel?.fetchImage{ [artworkImageView] image in
            DispatchQueue.main.async {
                UIView.transition(
                    with: artworkImageView,
                    duration: 0.25, options: [.curveEaseIn],
                    animations: {
                        artworkImageView.image = image
                })
            }
        }
    }
    
    private func setupLabels() {
        DispatchQueue.main.async { [viewModel, titleLabel, subtitleLabel] in
            titleLabel.text = viewModel?.title
            subtitleLabel.text = viewModel?.subtitle
        }
    }
    
    // MARK: - Layout
    
    private func addSubViews() {
        constrainImageView()
        constrainStackView()
    }
    
    private func constrainImageView() {
        contentView.addSubview(artworkImageView)
        artworkImageView.anchor(
            left: contentView.leftAnchor,
            leftConstant: Metrics.Margin.default,
            widthConstant: imageViewSide,
            heightConstant: imageViewSide
        )
        artworkImageView.anchorCenterYToSuperview()
    }
    
    private func constrainStackView() {
        contentView.addSubview(labelsStackView)
        labelsStackView.anchor(
            left: artworkImageView.rightAnchor,
            right: contentView.rightAnchor,
            leftConstant: Metrics.Margin.default,
            rightConstant: Metrics.Margin.default
        )
        labelsStackView.centerYAnchor.constraint(
            equalTo: artworkImageView.centerYAnchor
        ).isActive = true
        labelsStackView.heightAnchor.constraint(
            equalTo: artworkImageView.heightAnchor,
            multiplier: 0.75
        ).isActive = true
    }
    
}
