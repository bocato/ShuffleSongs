//
//  CacheService.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
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
    
    /// Initializes a cache service.
    ///
    /// - Parameter fileManager: The file manager for the service, for checking if file or directory exists in a specified path.
    ///   - documentDirectoryPath: The path of the document directory.
    init(fileManager: FileManager, cacheDirectoryName: String)
    
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
    func loadData(from key: String, completion: ((_ result: Result<Data, CacheServiceError>) -> Void))

    /// Clears the cache.
    ///
    /// - Parameter completion: Returns whether the cache could be clearedor not.
    func clear(completion: ((_ result: Result<Data, CacheServiceError>) -> Void)?)
    
}

/// Save and load data to memory and disk cache.
public final class CacheService: CacheServiceProvider {
    
    /// For getting or loading data in memory.
    private let memory = NSCache<NSString, NSData>()
    
    /// The path url that contains cached files (mp3 and image files).
    private let diskPath: URL
    
    /// For checking whether file or directory exists in a specified path.
    private let fileManager: FileManager
    
    /// Makes sure all operation are executed serially.
    private let serialQueue = DispatchQueue(label: "CacheService")
    
    // MARK: - Initialization
    
    /// Initializes a cache service.
    ///
    /// - Parameters:
    ///   - fileManager: The file manager for the service, for checking if file or directory exists in a specified path.
    ///   - cacheDirectoryName: The path of the cache directory.
    public init(fileManager: FileManager = FileManager.default,
                cacheDirectoryName: String) {
        self.fileManager = fileManager
        do {
            let cachesDirectory = try fileManager.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            diskPath = cachesDirectory.appendingPathComponent(cacheDirectoryName)
            try createDirectoryIfNeeded()
        } catch {
            fatalError()
        }
    }
    
    // MARK: - Public functions
    
    public func save(data: Data,
                     key: String,
                     completion: ((_ result: Result<Void, CacheServiceError>) -> Void)? = nil) {
        
        guard let encriptedKey = key.sha256 else {
            completion?(.failure(.encryptionFailed))
            return
        }
        
        serialQueue.async {
            self.memory.setObject(data as NSData, forKey: encriptedKey as NSString)
            do {
                try data.write(to: self.filePath(key: encriptedKey))
                completion?(.success(()))
            } catch {
                completion?(.failure(.couldNotSaveData))
            }
        }
    }

    public func loadData(from key: String,
                         completion: ((Result<Data, CacheServiceError>) -> Void)) {
        
        guard let encriptedKey = key.sha256 else {
            completion(.failure(.encryptionFailed))
            return
        }
        
        if let dataFromMemory = memory.object(forKey: encriptedKey as NSString) {
            completion(.success(dataFromMemory as Data))
        } else if let dataFromDisk = getDataFromDisk(for: encriptedKey) {
            completion(.success(dataFromDisk as Data))
        } else {
            completion(.failure(.couldNotLoadData))
        }
        
    }
    
    public func clear(completion: ((_ result: Result<Data, CacheServiceError>) -> Void)? = nil) {
        serialQueue.async {
            self.memory.removeAllObjects()
            do {
                let files = try self.fileManager.contentsOfDirectory(at: self.diskPath, includingPropertiesForKeys: nil, options: [])
                try files.forEach {
                    try self.fileManager.removeItem(at: $0)
                }
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
    
    private func getDataFromDisk(for encriptedKey: String) -> Data? {
        let filePath = self.filePath(key: encriptedKey)
        guard let nsData = NSData(contentsOf: filePath), self.fileManager.fileExists(atPath: filePath.path) else {
            return nil
        }
        return nsData as Data
    }

}
