//
//  ArtistLookupRequest.swift
//  ShuffleSongs
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Networking

/// Defines the requests for the quiz endpoint
enum ArtistLookupRequest: URLRequestProtocol {
    
    case lookup([String])
    
    var baseURL: URL {
        return Environment.shared.baseURL
    }
    
    var path: String? {
        switch self {
        case .lookup:
            return "lookup"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .lookup:
            return .get
        }
    }
    
    var parameters: URLRequestParameters? {
        switch self {
        case let .lookup(artistIDs):
            let ids = artistIDs.joined(separator: ",")
            let parameters = [
                "id": ids,
                "limit": "5"
            ]
            return .url(parameters)
        }
    }
    
    var headers: [String : String]? {
        return ["content-type": "application/json"]
    }
    
}
