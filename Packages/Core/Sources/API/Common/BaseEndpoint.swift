//
//  BaseEndpoint.swift
//  Core
//
//  Created by Dorian on 11/05/2025.
//

import Foundation
import Networking

public class BaseEndpoint: Endpoint, CustomStringConvertible, @unchecked Sendable {
    public var method: Networking.Method { .get }
    public var scheme: Scheme { .https }
    public var host: String { "api.spacexdata.com" }
    public var path: String { "/v4" }
    public var query: [URLQueryItem]? { nil }
    public var fragment: String? { nil }

    public var headers: Headers {
        var headers = Headers()
        headers.accept = .application(.json)
        headers.contentType = .application(.json)
        return headers
    }

    public func url() throws -> URL {
        var components: URLComponents = .init()
        components.scheme = scheme.rawValue
        components.host = host
        components.path = path
        components.queryItems = query
        components.fragment = fragment

        guard let url = components.url else {
            assertionFailure("Cannot build url from components: \(components.debugDescription)")
            throw URLError(.badURL)
        }
        
        return url
    }

    public var description: String {
        "Request"
    }
}
