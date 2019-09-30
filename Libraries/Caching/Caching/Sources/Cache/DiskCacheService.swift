//
//  DiskCacheService.swift
//  Caching
//
//  Created by Eduardo Sanches Bocato on 29/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

/// Save and load data to memory and disk cache.
public final class DiskCacheService: CacheServiceProvider {
    
    /// The path url that contains cached files (mp3 and image files).
    private let diskPath: URL
    
    /// For checking whether file or directory exists in a specified path.
    private let fileManager: FileManager
    
    /// Makes sure all operation are executed serially.
    private let serialQueue: DispatchQueue
    
    // MARK: - Initialization
    
    /// Initializes a cache service.
    ///
    /// - Parameters:
    ///   - fileManager: The file manager for the service, for checking if file or directory exists in a specified path.
    ///   - serialQueue: The queue were the operations will run.
    ///   - cacheDirectoryName: The path of the cache directory.
    public init(
        fileManager: FileManager = FileManager.default,
        serialQueue: DispatchQueue = DispatchQueue(label: "DiskCacheService"),
        cacheDirectoryName: String
    ) throws {
        self.fileManager = fileManager
        self.serialQueue = serialQueue
        let cachesDirectory = try fileManager.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        diskPath = cachesDirectory.appendingPathComponent(cacheDirectoryName)
        try createDirectoryIfNeeded()
    }
    
    // MARK: - Saving
    
    public func save(data: Data,
                     key: String,
                     completion: ((_ result: Result<Void, CacheServiceError>) -> Void)? = nil
    ) {
        
        serialQueue.async { [weak self] in
            
            guard let self = self else { return }
            
            do {
                try data.write(to: self.filePath(key: key))
                completion?(.success(()))
            } catch {
                completion?(.failure(.couldNotSaveData))
            }
            
        }
        
    }
    
    // MARK: - Data Loading
    
    public func loadData(
        from key: String,
        completion: @escaping ((Result<Data, CacheServiceError>) -> Void)
    ) {
        
        serialQueue.async { [weak self] in
            
            guard let self = self else { return }
            
            let filePath = self.filePath(key: key)
            guard let nsData = NSData(contentsOf: filePath), self.fileManager.fileExists(atPath: filePath.path) else {
                completion(.failure(.couldNotLoadData))
                return
            }
            
            completion(.success(nsData as Data))
        }
        
    }
    
    // MARK: - Cleaning Caches
    
    public func clear(_ completion: ((Result<Void, CacheServiceError>) -> Void)? = nil) {
        serialQueue.async { [weak self] in
            guard let self = self else { return }
            do {
                let files = try self.fileManager.contentsOfDirectory(at: self.diskPath, includingPropertiesForKeys: nil, options: [])
                try files.forEach {
                    try self.fileManager.removeItem(at: $0)
                }
                completion?(.success(()))
            } catch {
                completion?(.failure(.raw(error)))
            }
        }
    }
    
    // MARK: - Private Functions
    
    private func filePath(key: String) -> URL {
        return diskPath.appendingPathComponent(key)
    }
    
    private func createDirectoryIfNeeded() throws {
        // Get document directory for device, this should succeed
        if fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first != nil {
            
            // If folder URL does not exist, create it
            if !fileManager.fileExists(atPath: diskPath.path) {
                try fileManager.createDirectory(atPath: diskPath.path,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            }
        }
    }
    
}
