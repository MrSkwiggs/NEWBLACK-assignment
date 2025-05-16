# Networking Package Documentation

The Networking package provides a clean, protocol-oriented Swift networking layer for iOS applications. It offers abstractions for HTTP requests, responses, MIME types, and other common networking concerns with a focus on type safety and extensibility.

## Table of Contents

- [Networking Package Documentation](#networking-package-documentation)
  - [Table of Contents](#table-of-contents)
  - [Installation](#installation)
  - [Basic Usage](#basic-usage)
    - [Creating a Simple Request](#creating-a-simple-request)
    - [Request with JSON Body](#request-with-json-body)
    - [Authenticated Request](#authenticated-request)
  - [Components](#components)
    - [Requests \& Endpoints](#requests--endpoints)
    - [Headers](#headers)
    - [MIME Types](#mime-types)
    - [Request Performer](#request-performer)
  - [Advanced Usage](#advanced-usage)
    - [Paginated Requests](#paginated-requests)
    - [Custom Response Handling](#custom-response-handling)
  - [Technical Considerations](#technical-considerations)
    - [Thread Safety](#thread-safety)
    - [Error Handling](#error-handling)
    - [Memory Management](#memory-management)
    - [Testing](#testing)
    - [Performance](#performance)
    - [Best Practices](#best-practices)

## Installation

Add the Networking package to your project by including it as a local package dependency:

```swift
dependencies: [
    .package(path: "../Networking")
]
```

## Basic Usage

### Creating a Simple Request

```swift
// Define a simple endpoint
class UserEndpoint: Request {
    typealias Response = Data
    
    var scheme: Scheme = .https
    var host: String = "api.example.com"
    var path: String = "/users"
    var query: [URLQueryItem]? = nil
    var fragment: String? = nil
    var headers: Headers = [:]
    
    func url() throws -> URL {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host
        components.path = path
        components.queryItems = query
        components.fragment = fragment
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        return url
    }
}

// Perform the request
let performer = RequestPerformer()
let userEndpoint = UserEndpoint()

Task {
    do {
        let data = try await performer.send(userEndpoint)
        // Process the data
    } catch {
        // Handle error
    }
}
```

### Request with JSON Body

```swift
class CreateUserEndpoint: Request, BodyProvider {
    typealias Response = User
    typealias ProvidedBody = CreateUserRequest
    
    struct CreateUserRequest: Codable {
        let name: String
        let email: String
    }
    
    var scheme: Scheme = .https
    var host: String = "api.example.com"
    var path: String = "/users"
    var query: [URLQueryItem]? = nil
    var fragment: String? = nil
    var headers: Headers = [:]
    var body: CreateUserRequest
    
    init(name: String, email: String) {
        self.body = CreateUserRequest(name: name, email: email)
        headers.contentType = .application(.json)
    }
    
    func url() throws -> URL {
        // Implementation as above
    }
}

// Usage
let createUser = CreateUserEndpoint(name: "John Doe", email: "john@example.com")
let user = try await performer.send(createUser)
```

### Authenticated Request

```swift
class AuthenticatedUserEndpoint: AuthenticatedEndpoint, Request {
    typealias Response = User
    
    var scheme: Scheme = .https
    var host: String = "api.example.com"
    var path: String = "/me"
    var query: [URLQueryItem]? = nil
    var fragment: String? = nil
    var headers: Headers = [:]
    var authorization: Headers.Authorization?
    
    init(token: String) {
        self.authorization = .bearer(token: token)
        headers.authorization = authorization
    }
    
    func url() throws -> URL {
        // Implementation as above
    }
}
```

## Components

### Requests & Endpoints

The package provides several protocols for defining network requests:

- `Endpoint`: Base protocol for defining API endpoints
- `Request`: Protocol for network requests with response handling
- `AuthenticatedEndpoint`: Protocol for endpoints requiring authentication
- `BodyProvider`: Protocol for requests with bodies

### Headers

The `Headers` struct provides a type-safe way to work with HTTP headers:

```swift
// Create headers
var headers = Headers()
headers.contentType = .application(.json)
headers.accept = .application(.json)
headers.authorization = .bearer(token: "your-token")

// Access header values
if let contentType = headers.contentType {
    print(contentType.rawValue)
}
```

### MIME Types

The package includes a comprehensive hierarchy of MIME types:

```swift
// Using standard MIME types
let jsonType: MimeType = .application(.json)
let pngType: MimeType = .image(.png)
let formData: MimeType = .multipart(.form())

// Checking MIME type categories
if jsonType.isApplication {
    print("This is an application MIME type")
}
```

### Request Performer

The `RequestPerformer` handles the execution of requests:

```swift
let performer = RequestPerformer()

// Configure JSON encoding/decoding
let encoder = JSONEncoder()
let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase
let customPerformer = RequestPerformer(encoder: encoder, decoder: decoder)

// Add hooks
let hookingPerformer = RequestPerformer(
    hooks: .init(didSerialiseRequest: { request in
        var request = request
        request.timeoutInterval = 30
        return request
    })
)
```

## Advanced Usage

### Paginated Requests

```swift
class PaginatedUsersEndpoint: Request {
    typealias Response = [User]
    
    var scheme: Scheme = .https
    var host: String = "api.example.com"
    var path: String = "/users"
    var page: Int
    var perPage: Int
    
    init(page: Int = 1, perPage: Int = 20) {
        self.page = page
        self.perPage = perPage
    }
    
    var query: [URLQueryItem]? {
        [.page(page), .perPage(perPage)]
    }
    
    var fragment: String? = nil
    var headers: Headers = [:]
    
    func url() throws -> URL {
        // Implementation
    }
}
```

### Custom Response Handling

```swift
class CustomResponseEndpoint: Request {
    typealias Response = CustomResponse
    
    // ... other properties
    
    func receive(response: URLResponse, with data: Data, using decoder: JSONDecoder) throws -> CustomResponse {
        // Custom parsing logic
        guard let httpResponse = response as? HTTPURLResponse else {
            throw SomeError.invalidResponse
        }
        
        // Get headers from response
        let etag = httpResponse.allHeaderFields["ETag"] as? String
        
        // Decode body
        let body = try decoder.decode(ResponseBody.self, from: data)
        
        return CustomResponse(etag: etag, body: body)
    }
}
```

## Technical Considerations

### Thread Safety

- The package is designed with Swift's concurrency model in mind
- Most types are marked as `Sendable` to ensure thread safety
- `RequestPerformer` is designed to be used with async/await

### Error Handling

- Methods that can fail throw descriptive errors
- `HTTPStatusCode.Validation` provides flexible status code validation
- Custom error types allow for precise error handling

### Memory Management

- Care should be taken when capturing `RequestPerformer` in closures to avoid retain cycles
- For long-lived requests, consider weak references to avoid memory leaks

### Testing

- The package includes a test target for unit testing
- Request objects can be easily mocked for testing view models or controllers
- Use the `#if DEBUG` `curl` property to debug request details

### Performance

- Reuse `RequestPerformer` instances when possible
- Consider using a shared URLSession for related requests
- The package uses Swift's built-in JSON encoding/decoding for optimal performance

### Best Practices

- Group related endpoints in dedicated files or extensions
- Use type aliases for common response types
- Consider creating base classes for common endpoint patterns in your app