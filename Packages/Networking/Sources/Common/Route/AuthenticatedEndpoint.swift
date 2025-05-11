//
//  AuthenticatedEndpoint.swift
//  Networking
//

import Foundation

/// An endpoint that provides an authorization header.
public protocol AuthenticatedEndpoint: Endpoint {
    var authorization: Headers.Authorization? { get }
}
