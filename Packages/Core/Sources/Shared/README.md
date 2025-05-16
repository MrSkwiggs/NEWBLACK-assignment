# Core Package - Shared Target Documentation

The Shared target in the Core package provides fundamental services, utilities, and abstractions used across the NEWBLACK X application. This document outlines the architecture, key components, and usage patterns of the Shared target.

## Architecture Overview

The Shared target is built on a modular architecture with dependency injection at its core, leveraging the [Factory](https://github.com/hmlongco/Factory) framework. It provides:

1. **Domain Services** - Core functionality like date providers and storage solutions
2. **Feature Services** - App-specific business logic and data providers
3. **Composition** - Factory classes for dependency injection and composition

## Key Components

### Storage

#### KeyStore

The `KeyStore` provides a generic, key-value persistence abstraction with various implementations:

- `KeyStore.userDefaults` - Persists data using UserDefaults
- `KeyStore.keychain` - Securely stores sensitive data in the keychain
- `CachingKeyStore` - Adds time-based expiry to stored values

```swift
// Store a value
try keyStore.set("Hello World", for: "greeting")

// Retrieve a value
let greeting: String? = try keyStore.get(for: "greeting")

// Delete a value
keyStore.delete(key: "greeting")
```

### Providers

#### DateProvider

The `DateProvider` offers a testable abstraction for time-related operations:

```swift
let provider = DateProvider.main
let now = provider.now()
let futureDate = provider.date(after: 3600) // 1 hour from now
```

#### Data Providers

- `LaunchProvider` - Retrieves SpaceX launch data
- `RocketProvider` - Retrieves SpaceX rocket data
- `FilterProvider` - Manages date range filters for launches

```swift
// Fetch rockets
let rockets = try await rocketProvider.fetch(atPage: 0)

// Fetch a specific rocket
let falcon9 = try await rocketProvider.fetch(rocketByID: "5e9d0d95eda69955f709d1eb")

// Fetch launches with date filters
let launches = try await launchProvider.fetch(atPage: 0, filters: dateFilters)
```

### Dependency Injection

The Shared target uses the Factory pattern for dependency injection, with three primary factories:

#### DomainFactory

`DomainFactory` provides fundamental domain services:

```swift
let dateProvider = DomainFactory.shared.dateProvider()
let storage = DomainFactory.shared.userPreferenceStorage()
```

#### FeatureFactory

`FeatureFactory` provides access to feature-specific services:

```swift
let launchProvider = FeatureFactory.shared.launchProvider()
let rocketProvider = FeatureFactory.shared.rocketProvider()
let filterProvider = FeatureFactory.shared.filterProvider()
```

#### LaunchArgumentFactory

`LaunchArgumentFactory` provides access to app launch arguments:

```swift
let args = LaunchArgumentFactory.shared.launchArguments()
if args.contains(where: { if case .state(.failure) = $0 { return true } else { return false } }) {
    // Handle failure state
}
```

## Usage Patterns

### Accessing Services

The recommended pattern for accessing services is through the factory system:

```swift
import Shared

// In your SwiftUI view or view model
struct MyView: View {
    @Injected(\.featureFactory.launchProvider) 
    var launchProvider
    
    var body: some View {
        // Use launchProvider
    }
}
```

### Working with KeyStore

For persisting user preferences or app state:

```swift
let keyStore = DomainFactory.shared.userPreferenceStorage()

// Save user preference
try keyStore.set(userSettings, for: "user.settings")

// Retrieve preference
let settings: UserSettings? = try keyStore.get(for: "user.settings")
```

## Testing

The architecture promotes testability through dependency injection. For tests:

1. Create mock implementations of protocols like `LaunchProviding`
2. Inject these mocks through the factory system
3. Test business logic in isolation

The package includes test targets:
- `SharedTests` - Tests for the Shared target
- `APITests` - Tests for the API target

## Best Practices

1. **Dependency Injection** - Always access dependencies through factories
2. **Protocol-Oriented Design** - Work with protocol abstractions like `LaunchProviding` rather than concrete implementations
3. **Concurrency** - Respect actor isolation when working with providers that are actors
4. **Error Handling** - Handle errors from KeyStore operations appropriately

## Technical Considerations

### Thread Safety

- Most types are designed with Swift's concurrency model in mind
- Providers like `LaunchProvider` and `RocketProvider` are actors for thread safety
- `KeyStore` implementations are marked as `@unchecked Sendable` with appropriate synchronization

### Memory Management

- Factory singletons should be used where appropriate to avoid redundant instances