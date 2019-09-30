//
//  CacheServiceProvider.swift
//  Caching
//
//  Created by Eduardo Sanches Bocato on 29/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

/// Defines the CacheService errors.
///
/// - encryptionFailed: The key encription has failed.
/// - couldNotSaveData: The data could not be saved.
/// - couldNotLoadData: The data could not be loaded.
/// - raw: Some system error not previously defined.
public enum CacheServiceError: Error {
    case encryptionFailed
    case couldNotSaveData
    case couldNotLoadData
    case raw(Error)
}

/// Defines a cache service.
public protocol CacheServiceProvider {
    
    /// Saves some data in a key.
    ///
    /// - Parameters:
    ///   - data: The data to be saved.
    ///   - key: The key to save/retrieve the data.
    ///   - completion: Completion block with a result.
    /// - Returns: Void if successful, otherwise an error.
    func save(data: Data, key: String, completion: ((_ result: Result<Void, CacheServiceError>) -> Void)?)
    
    /// Loads the data from the cache (disk or memory).
    ///
    /// - Parameters:
    ///   - key: The key to fetch the data.
    ///   - completion: Completion block to get its result.
    func loadData(from key: String, completion: @escaping ((_ result: Result<Data, CacheServiceError>) -> Void))

    /// Clears the cache.
    ///
    /// - Parameter completion: Returns whether the cache could be clearedor not.
    func clear(_ completion: ((Result<Void, CacheServiceError>) -> Void)?)
    
}

