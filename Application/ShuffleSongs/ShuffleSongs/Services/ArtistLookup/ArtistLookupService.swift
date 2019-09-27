//
//  ArtistLookupService.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Networking

/// Defines possible errors within the ArtistLookupServiceProvider context
///
/// - networking: an error comming from the networking dispatcher
enum ArtistLookupServiceError: Error {
    case networking(NetworkingError)
}
protocol ArtistLookupServiceProvider {
    
    /// Requests a `ArtistLookupResponseEntity` from a URLRequest
    /// - Parameter ids: the array of artist ID's we want to lookup
    /// - Parameter completion: the result of the request, handed in a async manner
    func lookupArtistsWithIDs(
        _ ids: [String],
        completion: @escaping (Result<[ArtistLookupResponseEntity.Result], ArtistLookupServiceError>) -> Void
    )
    
}

/// Defines a service interface, to act as a gateway/middleware between the raw
/// networking responses and the expected result.
final class ArtistLookupService: ArtistLookupServiceProvider, CodableRequesting {
    
    // MARK: - Properties
    
    var dispatcher: URLRequestDispatching
    
    // MARK: - Initialization
    
    init(dispatcher: URLRequestDispatching) {
        self.dispatcher = dispatcher
    }
    
    // MARK: - ArtistLookupServiceProvider
    
    func lookupArtistsWithIDs(
        _ ids: [String],
        completion: @escaping (Result<[ArtistLookupResponseEntity.Result], ArtistLookupServiceError>
    ) -> Void) {
        
        let request: ArtistLookupRequest = .lookup(ids)
        
        requestCodable(request, ofType: ArtistLookupResponseEntity.self) { (networkingResult) in
            let resultToReturn = networkingResult
                .mapError { ArtistLookupServiceError.networking($0) }
                .map { $0.results }
            completion(resultToReturn)
        }
        
    }
    
}






