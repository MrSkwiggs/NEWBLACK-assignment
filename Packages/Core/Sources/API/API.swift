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
        // The following is needed because it's 2025 and Apple still doesn't know how to decode
        // ISO8601 dates with fractional seconds 😤
        decoder.dateDecodingStrategy = .custom { decoder in
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            guard let date = isoFormatter.date(from: dateString) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode ISO8601 date: \(dateString)")
            }
            return date
        }
        let encoder: JSONEncoder = .init()
        encoder.dateEncodingStrategy = .iso8601
        self.requestPerformer = RequestPerformer(session: .init(configuration: .ephemeral), encoder: encoder, decoder: decoder)
    }

    package func send<R: Request>(_ request: R) async throws -> R.Response {
        try await requestPerformer.send(request)
    }
}
