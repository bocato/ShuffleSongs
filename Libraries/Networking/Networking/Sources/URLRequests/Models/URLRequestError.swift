//
//  URLRequestError.swift
//  Networking
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

private let domain = "URLRequestError"

/// Defines URLRequestErrors.
///
/// - raw: An error comming from the system that conforms to Error.
/// - unknown: Unknown error.
/// - requestBuilderFailed: The request builder failed.
/// - withData: There is an error and it has a payload.
/// - invalidHTTPURLResponse: The HTTPURLResponse object returned from the `URLDataTask` was `nil`.
public enum URLRequestError: Error {
    
    case raw(Error)
    case unknown
    case requestBuilderFailed
    case withData(Data, Error?)
    case invalidHTTPURLResponse
    
    public var code: Int {
        switch self {
        case let .raw(error):
            let nsError = error as NSError
            return nsError.code
        case .unknown:
            return -1
        case .requestBuilderFailed:
            return -2
        case let .withData(_, error):
            let nsError = error as NSError?
            return nsError?.code ?? -3
        case .invalidHTTPURLResponse:
            return -4
        }
    }
    
    public var localizedDescription: String {
        switch self {
        case let .raw(error):
            return error.localizedDescription
        case .unknown:
            return "Unknown error."
        case .requestBuilderFailed:
            return "The request builder failed."
        case let .withData(_, error):
            return error?.localizedDescription ??
            "You should check the `errorData key on the `userInfo` of `rawError` property."
        case .invalidHTTPURLResponse:
            return "The HTTPURLResponse object returned from the `URLDataTask` was `nil`."
        }
    }
    
    public var rawError: NSError {
        switch self {
        case let .raw(error):
            return error as NSError
        case .unknown:
            return NSError(domain: domain, code: code, description: localizedDescription)
        case .requestBuilderFailed:
            return NSError(domain: domain, code: code, description: localizedDescription)
        case let .withData(data, originalError):
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []), let errorData = jsonObject as? [String: Any] else {
                return URLRequestError.unknown.rawError
            }
            let userInfo: [String: Any] = [
                "originalError": originalError ?? "",
                "errorData": errorData
            ]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        case .invalidHTTPURLResponse:
            return NSError(domain: domain, code: code, description: localizedDescription)
        }
    }
    
}
