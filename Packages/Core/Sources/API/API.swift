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
        decoder.dateDecodingStrategy = .iso8601FractionalSeconds
        let encoder: JSONEncoder = .init()
        encoder.dateEncodingStrategy = .iso8601
        self.requestPerformer = RequestPerformer(session: .init(configuration: .ephemeral), encoder: encoder, decoder: decoder)
    }

    package func send<R: Request>(_ request: R) async throws -> R.Response {
        try await requestPerformer.send(request)
    }
}

private extension JSONDecoder.DateDecodingStrategy {
    /// Custom date decoding strategy for ISO 8601 with fractional seconds.
    static var iso8601FractionalSeconds: JSONDecoder.DateDecodingStrategy {
        .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            guard let date = isoFormatter.date(from: dateString) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode ISO8601 date with fractional seconds: \(dateString)")
            }
            return date
        }
    }
}
