//
//  MusicListTableViewCellViewModel+Fixtures.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 29/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

@testable import ShuffleSongs

extension MusicListTableViewCellViewModel {
    static var dummy: MusicListTableViewCellViewModel {
        let dataModel = MusicListItemViewData(
            imageURL: nil,
            title: "",
            subtitle: ""
        )
        return MusicListTableViewCellViewModel(
            dataModel: dataModel,
            imagesService: ImagesServiceProviderDummy()
        )
    }
}
