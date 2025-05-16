# Core Package - Entities Target Documentation

The Entities target in the Core package provides the fundamental data models and supporting types used throughout the NEWBLACK X application. This document outlines the architecture, key components, and usage patterns of the Entities target.

## Architecture Overview

The Entities target is built around a clean, protocol-oriented design with a focus on type safety and extensibility. It follows Swift best practices for making models Codable, Hashable, and Identifiable where appropriate, with a strong focus on immutability.

## Key Components

### Data Transfer Objects (DTOs)

The core of the Entities target is its DTOs, representing data retrieved from the SpaceX API:

#### Base Protocols

- `APIModel` - Base protocol for all API models, enforcing `Sendable`, `Decodable`, `Equatable`, and `Hashable`
- `DTO` - Extends `APIModel` with `Identifiable` and associates a `Field` type
- `DTOField` - Protocol for enum types that represent DTO fields

#### SpaceX Models

- `Rocket` - Model representing SpaceX rockets
- `Launch` - Model representing launch events
- `Launchpad` - Model representing launch facilities
- `Links` - Media links related to launches
- `Engines` - Engine specifications
- `ISP` - Specific impulse measurements
- `Thrust` - Engine thrust specifications
- `Launch.Failure` - Launch failure details

### Pagination

The `Paginated<Item>` generic wrapper provides a structured way to handle paginated responses from the API:

```swift
// Example of a paginated response
let paginatedRockets: Paginated<Rocket> = try await rocketProvider.fetch(atPage: 0)

// Access the data
let rockets = paginatedRockets.items
let currentPage = paginatedRockets.page
let hasNextPage = paginatedRockets.nextPage != nil
```

### Unit Extensions

The Entities target includes custom unit types for specialized measurements:

- `UnitForce` - Custom dimension for force measurements (newtons, kN, etc.)

### JSON Decoding Utilities

The target includes utilities for making JSON decoding more robust:

- `DynamicCodingKey` - Runtime-defined coding keys
- `JSONCoding+Convenience` - Extensions to simplify decoding with convenience methods

Example usage:

```swift
// Standard decoding
let container = try decoder.container(keyedBy: CodingKeys.self)
let value: Int = try container.decode(Int.self, forKey: .value)

// Decoding using convenience extensions
let value: Int = try container.decode(.value) // decoding type is inferred

// Using dynamic coding keys
let container = try decoder.container(keyedBy: DynamicCodingKey.self)
let value: Int = try container.decode("dynamicKey")
```

### UI Support

The target includes types to support UI implementation:

- `ViewIdentifiersProviding` - Protocol for providing UI accessibility identifiers
- `BaseViewIdentifiers` - Base implementation of view identifiers
- `ViewIdentifiers` - Application-specific view identifiers
- `LaunchArgument` - Launch arguments for app configuration

### Filtering

Support for filtering data:

- `DateRangeFilter` - Date range filtering for launches

## Usage Patterns

### Working with DTOs

The DTO models are designed to be used directly from API responses:

```swift
// Get a rocket
let rocket: Rocket = try await api.send(rocketEndpoint)

// Access properties
let rocketName = rocket.name
let engineCount = rocket.engines.count
let thrustAtSeaLevel = rocket.engines.thrust.seaLevel.value
```

### Creating Custom Type-Safe Queries

Using the DTO Field types allows for type-safe queries:

```swift
// Type-safe field reference
let dateFilter = Launch.Filter.greaterThan(field: .date, value: startDate)

// Type-safe sorting
let dateSort = Launch.Option.Sort.by(.date, .reverse)
```

### UI Identification

The ViewIdentifiers system provides consistent accessibility identifiers:

```swift
import SwiftUI

struct MyView: View {
    var body: some View {
        VStack {
            Text("Hello")
            
            Button("Action") {
                // Action
            }
            .elementIdentifier(\.myView.actionButton)
        }
        .rootIdentifier(\.myView)
    }
}
```

## Technical Considerations

### Thread Safety

All models in the Entities target conform to `Sendable` to ensure thread safety when used with Swift concurrency.

### JSON Decoding

The DTOs contain custom `init(from decoder:)` implementations to handle the specific formats of the SpaceX API, including:
- Nested containers for certain fields (e.g., measurements)
- Type conversions (e.g., percentages represented as integers)
- Date formatting

### Memory Management

The Entities models use value types (structs) to avoid reference cycles and minimize memory management concerns.

## Best Practices

1. **Immutable Models** - All DTOs are designed with immutable properties
2. **Clear Interface Boundaries** - Public APIs are clearly marked, with package-internal features properly encapsulated
3. **Protocol Conformance** - Consistent protocol usage across models
4. **Documentation** - All public types include comprehensive documentation comments

## Extending the System

When adding new DTOs:

1. Implement the `APIModel` protocol for basic models
2. Implement the `DTO` protocol for identifiable models that need field enumeration
3. Create an enum conforming to `DTOField` for type-safe field references
4. Implement custom decoding logic as needed to handle API response formats