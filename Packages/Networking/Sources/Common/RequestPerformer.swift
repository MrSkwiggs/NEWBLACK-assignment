//
//  RequestPerformer.swift
//  Networking
//

import Foundation

/// A basic implementation request performer that uses URLSession to perform requests.
public final class RequestPerformer: Sendable {

    public let encoder: JSONEncoder
    public let decoder: JSONDecoder

    let session: URLSession

    /// User-defined hooks for request handling.
    private let hooks: Hooks

    public init(
        session: URLSession = .shared,
        encoder: JSONEncoder = .init(),
        decoder: JSONDecoder = .init(),
        hooks: Hooks = .init()
    ) {
        self.encoder = encoder
        self.decoder = decoder
        self.session = session
        self.hooks = hooks
    }

    public func serialise<R: Request>(_ request: R) throws -> URLRequest {
        var urlRequest = URLRequest(url: try request.url())
        urlRequest.httpMethod = request.method.rawValue

        urlRequest.allHTTPHeaderFields = request.headers.all

        if let bodyProvider = request as? (any BodyProvider) {
            urlRequest.httpBody = try bodyProvider.body(with: encoder)
        }

        return hooks.didSerialiseRequest?(urlRequest) ?? urlRequest
    }

    public func send(_ request: URLRequest) async throws -> (Data, URLResponse) {
        return try await session.data(for: request)
    }

    public func send<R: Request>(_ request: R) async throws -> R.Response {
        let urlRequest = try serialise(request)

        let (data, response) = try await send(urlRequest)

        try validate(response, for: request)

        return try request.receive(response: response, with: data, using: decoder)
    }

    public func validate<R: Request>(_ response: URLResponse, for request: R) throws {
        guard let response = response as? HTTPURLResponse else { return }

        let statusCode = response.httpStatusCode
        guard request.statusCodeValidation.matches(code: statusCode) else {
            throw Error.unexpectedStatusCode(statusCode, expected: request.statusCodeValidation)
        }
    }

    public enum Error: Swift.Error, Sendable, CustomDebugStringConvertible, CustomStringConvertible {
        case unexpectedStatusCode(HTTPStatusCode, expected: HTTPStatusCode.Validation)

        public var description: String {
            switch self {
            case .unexpectedStatusCode(let httpStatusCode, let expected):
                "Unexpected status code \(httpStatusCode). Expected \(expected) instead"
            }
        }

        public var debugDescription: String { description }
    }
}

public extension RequestPerformer {
    /// Hooks for request handling.
    struct Hooks: Sendable {
        let didSerialiseRequest: (@Sendable (URLRequest) -> URLRequest)?

        public init(didSerialiseRequest: (@Sendable (URLRequest) -> URLRequest)? = nil) {
            self.didSerialiseRequest = didSerialiseRequest
        }
    }
}
