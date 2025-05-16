# Core Package - API Target Documentation

The API target in the Core package provides a structured interface for interacting with the SpaceX API. This document explains the architecture, key components, and usage patterns of the API target.

## Architecture Overview

The API target is built on top of the Networking package, providing SpaceX API-specific abstractions. It follows a clean, protocol-oriented design with a focus on type safety and modularity.

### Key Components

1. `API` - Central entry point for making API requests
2. `BaseEndpoint` - Base class for all SpaceX API endpoints
3. `Query` - Flexible query system for filtering API requests
4. Endpoint implementations for different SpaceX resources (Launches, Rockets)

## API Client

The `API` class serves as the main entry point for making requests to the SpaceX API. It configures a `RequestPerformer` with proper JSON encoding/decoding strategies and handles sending requests.

```swift
// Example usage
let launches = try await API.shared.send(Launches.Latest())
```

## Endpoints

The API is organized around resource-specific endpoints. Each endpoint extends `BaseEndpoint`, which provides common configuration for SpaceX API requests.

### Available Endpoints

- **Launches**
  - `Launches.Latest` - Get the latest launches
  - `Launches.QueryRequest` - Query launches with filters and pagination

- **Rockets**
  - `Rockets.QueryRequest` - Query rockets with filters and pagination

## Query System

The `Query<Item>` system provides a powerful way to filter, sort, paginate, and customize API requests.

### Filters

`Query.Filter` supports various operations:

- `.equals(field:, value:)` - Exact matching
- `.contains(field:, values:)` - Check if field value is in a set
- `.greaterThan(field:, value:, inclusive:)` - Greater than comparisons
- `.lessThan(field:, value:, inclusive:)` - Less than comparisons
- `.range(field:, range:)` - Range queries
- Logical operations: `.and([Filter])`, `.or([Filter])`

### Options

`Query.Option` provides request customization:

- `.select(fields:)` - Select specific fields
- `.pagination(Pagination)` - Paginate results
- `.populate(fields:)` - Populate nested fields
- `.sort([Sort])` - Sort results

### Sorting

`Query.Option.Sort` allows sorting by any field:

```swift
.sort([.by(.date, .reverse), .by(.name, .forward)])
```

## Pagination

The API supports pagination through `Query.Option.Pagination` and `PaginatedRequest`:

```swift
.pagination(.init(page: 0, pageSize: 10))
```

## Example Usage

### Fetching Latest Launches

```swift
let latestLaunches = try await API.Launches.getLatest()
```

### Querying Upcoming Launches

```swift
let upcomingLaunches = try await API.Launches.upcoming(
    sort: [.by(.date, .forward)],
    page: 0,
    pageSize: 10
)
```

### Fetching Rockets

```swift
let rockets = try await API.Rockets.fetchAll(page: 0, pageSize: 20)
```

### Custom Query with Filters

```swift
let customLaunches = try await API.Launches.query(
    filter: .range(field: .date, range: startDate...endDate),
    populate: [.launchpad, .rocket],
    sort: [.by(.date, .reverse)],
    page: 0,
    pageSize: 20
)
```

## Type Safety

The API target uses generics extensively to ensure type safety when working with different resources and their fields. Each DTO type includes convenience typealias for `Filter` and `Option` for improved readability.

## Caveats

### Query Options: Select and Populate

When using the `.select` and `.populate` query options, be careful about their impact on response decoding:

#### Select Option

The `.select(fields:)` option restricts which fields are returned in the API response. This can cause decoding errors if your model expects fields that aren't included in the response:

```swift
// RISKY: This will likely fail to decode into a full Launch object
let launchesWithOnlyIDs = try await API.Launches.query(
    select: [.id],  // Only requesting ID field
    page: 0,
    pageSize: 10
)
```

In the example above, attempting to decode the response into a `Launch` object will fail because the `Launch` struct expects other fields that weren't requested.

#### Populate Option

The `.populate(fields:)` option expands nested objects that would normally be returned as just IDs. Using this option with response types that don't expect expanded objects can also lead to decoding failures:

```swift
// Make sure your Launch model can handle populated rocket data
let launchesWithRocketDetails = try await API.Launches.query(
    populate: [.rocket],
    page: 0,
    pageSize: 10
)
```

### Best Practices

1. **Match model to query:** Ensure your model structure matches what you're requesting
2. **Use specialized response types:** Consider creating specialized response types for requests with limited fields
3. **Test thoroughly:** Validate that your queries and response models work together before shipping to production

## Testing

The API target includes a test suite to ensure reliability and correctness.

### Query System Tests

The `QueryTests` suite validates the correct encoding of query filters and options.