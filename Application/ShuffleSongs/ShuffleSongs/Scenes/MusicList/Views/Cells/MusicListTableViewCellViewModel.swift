//
//  MusicListTableViewCellViewModel.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation
import Networking
import UIKit

/// Defines the display logic for `MusicListTableViewCell`
protocol MusicListCellDisplayLogic {
    /// Fetches an image to be shown set on the ImageView
    func fetchImage(_ completion: @escaping (UIImage) -> Void)
    
    // Gets the View Title
    var title: String { get }
    
    // Gets the View Subtitle
    var subtitle: String { get }
}

/// Defines the business logic for `MusicListTableViewCell`
protocol MusicListCellBusinessLogic {
    /// Cancels the image request when needed
    func cancelImageRequest()
}

/// Defines an interface for the `MusicListTableViewCellViewModel`
protocol MusicListTableViewCellViewModelProtocol: MusicListCellDisplayLogic, MusicListCellBusinessLogic {}

/// Defines a ViewModel for the cell
final class MusicListTableViewCellViewModel: MusicListTableViewCellViewModelProtocol {
    
    // MARK: - Dependencies
    
    private let dataModel: MusicListItemViewData
    private let imagesService: ImagesServiceProvider
    
    // MARK: - Private Properties
    
    private var imageRequestToken: URLRequestToken?
    
    // MARK: - Computed Properties
    
    var title: String {
        return dataModel.title
    }
    
    var subtitle: String {
        return dataModel.subtitle
    }
    
    
    // MARK: - Initialization
    
    init(
        dataModel: MusicListItemViewData,
        imagesService: ImagesServiceProvider
    ) {
        self.dataModel = dataModel
        self.imagesService = imagesService
    }
    
}

// MARK: - Display Logic
extension MusicListTableViewCellViewModel: MusicListCellDisplayLogic {
    
    func fetchImage(_ completion: @escaping (UIImage) -> Void) {
        
        guard let imageURLString = dataModel.imageURL else {
            completion(.logo)
            return
        }
        
        imageRequestToken = imagesService.getImageDataFromURL(imageURLString) { (result) in
            
            guard let imageData = try? result.get(),
                let image = UIImage(data: imageData)
            else {
                completion(.logo)
                return
            }
            
            completion(image)
            
        }
    }
    
}


// MARK: - MusicListTableViewCellViewModelBusinessLogic
extension MusicListTableViewCellViewModel: MusicListCellBusinessLogic {
    
    func cancelImageRequest() {
        imageRequestToken?.cancel()
    }
    
}
