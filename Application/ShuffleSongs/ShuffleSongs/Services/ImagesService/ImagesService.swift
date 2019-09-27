//
//  ImagesService.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Networking

enum ImagesServiceError: Error {
    case invalidURL(String)
    case emptyData
    case network(Error)
    case unexpected
}

protocol ImagesServiceProvider {
    /// Gets and image from the URL. May be in cache or fetched from the network.
    ///
    /// - Parameters:
    ///   - url: The image URL.
    ///   - completionHandler: The completion handler for the fetch operation.
    /// - Returns: An image on success or a networking error on failure.
    @discardableResult
    func getImageDataFromURL(
        _ urlString: String,
        completion: @escaping (Result<Data, ImagesServiceError>) -> Void
    ) -> URLRequestToken?
}

final class ImagesService: ImagesServiceProvider, NetworkingService {
    
    // MARK: - Dependencies
    
    var dispatcher: URLRequestDispatching
    private let cacheService: CacheServiceProvider
    
    // MARK: - Initialization
    
    init(
        dispatcher: URLRequestDispatching,
        cacheService: CacheServiceProvider
    ) {
        self.dispatcher = dispatcher
        self.cacheService = cacheService
    }
    
    // MARK: - Public Functions
    
    @discardableResult
    func getImageDataFromURL(
        _ urlString: String,
        completion: @escaping (Result<Data, ImagesServiceError>) -> Void
    ) -> URLRequestToken? {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL(urlString)))
            return nil
        }
        
        var requestToken: URLRequestToken?
        
        cacheService.loadData(from: urlString) { [weak self] cacheResult in
            if let cachedData = try? cacheResult.get() {
                completion(.success(cachedData))
            } else {
                requestToken = self?.requestImageDataFromNetwork(url: url, completion: completion)
            }
        }
        
        return requestToken
        
    }
    
    private func requestImageDataFromNetwork(url: URL,
        completion: @escaping (Result<Data, ImagesServiceError>) -> Void
    ) -> URLRequestToken? {
        let request = SimpleURLRequest(url: url)
        return dispatcher.execute(request: request) { (networkResult) in
            do {
                guard let data = try networkResult.get() else {
                    completion(.failure(.emptyData))
                    return
                }
                completion(.success(data))
            } catch {
                completion(.failure(.network(error)))
            }
        }
    }
    
}
