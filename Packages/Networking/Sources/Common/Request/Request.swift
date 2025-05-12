import Foundation

/// A protocol representing a network request.
public protocol Request: Endpoint, CustomDebugStringConvertible, AnyObject {
    /// The type of response the request emits.
    associatedtype Response

    #if DEBUG
    /// Returns a cURL string representation of this request.
    var curl: String { get }
    #endif

    /// What HTTP Status codes the request expects to receive
    /// - note: Defaults to `.any(.success)`
    var statusCodeValidation: HTTPStatusCode.Validation { get }

    /// Instructs the request to receive the given response, with the given data and decoder so that it may attempt to construct a response.
    func receive(response: URLResponse, with data: Data, using decoder: JSONDecoder) throws -> Response
}

public extension Request {
    var method: Method { .get }

    #if DEBUG
    /**
     Returns a cURL command representation of this request.

     Use during debugging:

     `po print(<request>.curl)`
     */
    var curl: String {
        guard let url = try? url() else { return "Unable to serialise request" }

        var baseCommand = #"curl "\#(url.absoluteString)""#

        if method == .head {
            baseCommand += " --head"
        }

        var command = [baseCommand]

        if method != .get && method != .head {
            command.append("-X \(method)")
        }

        for (key, value) in headers.all where key != Headers.Key.cookie.rawValue {
            command.append("-H '\(key): \(value)'")
        }

        if let bodyRequest = self as? (any BodyProvider), let data = try? bodyRequest.body(with: .init()), let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }

        return command.joined(separator: " \\\n\t")
    }
    #endif

    var debugDescription: String {
        do {
            return """
            \(method.rawValue) \(try url())
            \(headers.all.map({ " - \($0.key): \($0.value)" }).joined(separator: "\n"))
            """
        } catch {
            return "\(Self.self)"
        }
    }

    var statusCodeValidation: HTTPStatusCode.Validation { .any(.success) }
}

public extension Request where Response: Decodable {
    func receive(response: URLResponse, with data: Data, using decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}

public extension Request where Response == Void {
    func receive(response: URLResponse, with data: Data, using decoder: JSONDecoder) throws -> Response {
        ()
    }
}

public extension Request where Response == Data {
    func receive(response: URLResponse, with data: Data, using decoder: JSONDecoder) throws -> Response {
        return data
    }
}
