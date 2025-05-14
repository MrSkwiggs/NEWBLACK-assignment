import Foundation

/// A protocol representing a type that has an encodable body.
public protocol BodyProvider {
    /// The type of the body.
    associatedtype ProvidedBody

    /// The body of the request.
    var body: ProvidedBody { get }

    /// Encodes the body using the specified encoder.
    func body(with encoder: JSONEncoder) throws -> Data
}

public extension Request where Self: BodyProvider {
    /// The HTTP method for the request. Defaults to POST.
    var method: Method { .post }
}

public extension BodyProvider where ProvidedBody: Encodable {
    func body(with encoder: JSONEncoder) throws -> Data {
        try encoder.encode(body)
    }
}

public extension BodyProvider where ProvidedBody == Data {
    func body(with encoder: JSONEncoder) throws -> Data {
        body
    }
}

