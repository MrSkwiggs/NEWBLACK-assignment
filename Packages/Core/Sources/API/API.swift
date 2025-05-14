//
//  API.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation
import Networking

/// A type that can send requests and receive responses for the SpaceX API.
public final class API: Sendable {

    private let requestPerformer: RequestPerformer

    package static let shared: API = .init()

    package init() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self.requestPerformer = RequestPerformer(session: .init(configuration: .ephemeral), decoder: decoder)
    }

    package func send<R: Request>(_ request: R) async throws -> R.Response {
        try await requestPerformer.send(request)
    }
}
