//
//  MemoryCacheService.swift
//  Caching
//
//  Created by Eduardo Sanches Bocato on 29/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

/// Save and load data to memory and disk cache.
public final class MemoryCacheService: CacheServiceProvider {
    
    /// For getting or loading data in memory.
    private let memory = NSCache<NSString, NSData>()
    
    /// Makes sure all operation are executed serially.
    private let serialQueue: DispatchQueue
    
    // MARK: - Initialization
    
    /// Initializes a cache service.
    ///
    /// - Parameters:
    ///   - serialQueue: The queue where the operations will run
    public init(serialQueue: DispatchQueue = DispatchQueue(label: "MemoryCacheService")) {
        self.serialQueue = serialQueue
    }
    
    // MARK: - Saving
    
    public func save(data: Data,
                     key: String,
                     completion: ((_ result: Result<Void, CacheServiceError>) -> Void)? = nil
    ) {
        
        serialQueue.async { [memory] in
            memory.setObject(data as NSData, forKey: key as NSString)
            completion?(.success(()))
        }
        
    }
    
    // MARK: - Data Loading
    
    public func loadData(
        from key: String,
        completion: @escaping ((Result<Data, CacheServiceError>) -> Void)
    ) {
        
        serialQueue.async { [memory] in
            
            guard let dataFromMemory = memory.object(forKey: key as NSString) else {
                completion(.failure(.couldNotLoadData))
                return
            }
               
            completion(.success(dataFromMemory as Data))
        }
        
    }
    
    // MARK: - Cleaning Caches
    
    public func clear(_ completion: ((Result<Void, CacheServiceError>) -> Void)? = nil) {
        serialQueue.async { [memory] in
            memory.removeAllObjects()
        }
    }

}
