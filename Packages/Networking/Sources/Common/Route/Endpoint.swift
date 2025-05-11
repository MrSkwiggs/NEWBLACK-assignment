import Foundation

/// A type representing the scheme of a URL.
public protocol Endpoint: Sendable {
    // MARK: Route
    /// The scheme of the endpoint (e.g., "https").
    var scheme: Scheme { get }
    /// The host of the endpoint.
    var host: String { get }
    /// The path of the endpoint.
    var path: String { get }
    /// Query Items for the endpoint.
    var query: [URLQueryItem]? { get }
    /// The fragment of the endpoint.
    var fragment: String? { get }

    // MARK: Request
    /// HTTP Headers for the endpoint.
    var headers: Headers { get }
    /// The HTTP method for the endpoint.
    var method: Method { get }

    /// Builds the URL for the endpoint.
    func url() throws -> URL
}
