//
//  AuthenticatedEndpoint.swift
//  Networking
//

import Foundation

public protocol AuthenticatedEndpoint: Endpoint {
    var authorization: Headers.Authorization? { get }
}
