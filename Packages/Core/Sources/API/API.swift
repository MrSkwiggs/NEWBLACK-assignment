//
//  API.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation
import Networking

public final class API: Sendable {

    private let requestPerformer: RequestPerformer

    package static let shared: API = .init()

    public init() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self.requestPerformer = RequestPerformer(decoder: decoder)
    }

    public func send<R: Request>(_ request: R) async throws -> R.Response {
        try await requestPerformer.send(request)
    }
}
