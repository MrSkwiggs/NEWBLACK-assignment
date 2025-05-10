//
//  AuthenticatedEndpoint.swift
//  Networking
//
//  Created by Dorian on 17/04/2025.
//

import Foundation

public protocol AuthenticatedEndpoint: Endpoint {
    var authorization: Headers.Authorization? { get }
}
