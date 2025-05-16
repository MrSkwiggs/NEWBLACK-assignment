# NEWBLACK X - Assignment

## Overview

NEWBLACK X is an iOS application that showcases SpaceX launches and rockets using a modern Swift architecture. The app demonstrates best practices in iOS development with SwiftUI, Swift Concurrency, and MVVM design patterns. It allows users to browse SpaceX launches and rockets, view detailed information, and apply filters.

## Author
Dorian Grolaux

## Table of Contents

- [NEWBLACK X - Assignment](#newblack-x---assignment)
  - [Overview](#overview)
  - [Author](#author)
  - [Table of Contents](#table-of-contents)
  - [Architecture](#architecture)
    - [Key Architectural Components](#key-architectural-components)
  - [Main Features](#main-features)
    - [Home Screen](#home-screen)
    - [Launches](#launches)
    - [Rockets](#rockets)
  - [UI Components](#ui-components)
  - [Data Flow](#data-flow)
    - [State Management](#state-management)
  - [Testing](#testing)
    - [UI Testing](#ui-testing)
  - [Debugging](#debugging)
  - [Project Structure](#project-structure)
  - [Package Documentation](#package-documentation)
    - [Networking Package](#networking-package)
    - [Core Package](#core-package)
  - [Getting Started](#getting-started)
  - [Technical Requirements](#technical-requirements)

## Architecture

NEWBLACK X follows a modular architecture with clear separation of concerns:

- **App Layer**: Main UI components, navigation, and view models
- **Feature Layer**: Business logic and UI implementation
- **Domain Layer**: Core business logic and data models
- **Package Layer**: Reusable components across the app

The application uses SwiftUI for the UI layer and follows the MVVM (Model-View-ViewModel) pattern for clear separation between UI and business logic.

### Key Architectural Components

- **ViewModelFactory**: Centralized factory for creating and injecting view models
- **ModelState**: Generic state management for handling loading, success, and error states
- **Dependency Injection**: Using the [Factory](https://github.com/hmlongco/Factory) framework

## Main Features

### Home Screen
The app provides a tab-based navigation with two main sections:

- **Launches Tab**: Browse all SpaceX launches
- **Rockets Tab**: Explore SpaceX rockets

### Launches

The Launches section provides:

- List of all SpaceX launches with pagination support
- Date range filtering to narrow down launches
- Detailed view of each launch including:
  - Launch details and status
  - Associated rocket information
  - Launchpad details
  - External links (Wikipedia, YouTube)

### Rockets

The Rockets section offers:

- List of all SpaceX rockets with pagination
- Detailed specifications for each rocket including:
  - Physical dimensions
  - Engine specifications
  - Success rate statistics
  - Image gallery

## UI Components

The app includes several reusable UI components:

- **AsyncGallery**: Image gallery with asynchronous loading
- **StickyHeaderList**: List with scaling sticky header
- **DateRangeFilter**: UI for selecting date ranges
- **WebView**: In-app web browser for external links
- **LabelledCapsule**: Consistent UI element for displaying labeled information

## Data Flow

1. **View Initialization**: Views are created with injected view models
2. **Data Loading**: View models request data from providers
3. **State Management**: Views react to changes in model state
4. **User Interaction**: Actions are passed to view models to update state or fetch new data

### State Management

The `ModelState` enum provides a consistent way to handle different states:

- `loading`: Shows placeholders while data is being fetched
- `loaded`: Displays the fetched items
- `noContent`: Presents a message when no data is available
- `error`: Shows an error message with retry option

## Testing

NEWBLACK X includes both unit tests and UI tests:

- **Unit Tests**: Test view models and model state logic
- **UI Tests**: Integration tests using the Page Object pattern
- **TestPlan**: Configured test plan for running all tests

### UI Testing

The app implements the Page Object pattern for UI testing, making tests more maintainable:

- **BasePage**: Abstract base class for all page objects
- **HomePage**: Represents the main tabs interface
- **LaunchesPage**: Represents the launches list
- **LaunchPage**: Represents a specific launch detail screen

## Debugging

The app includes several features to help with debugging:

- **Launch Arguments**: Configure mock behavior with launch arguments
- **Mock Providers**: Substitute real API calls with predictable responses
- **Mock Durations**: Simulate network delays for testing loading states

## Project Structure

```
NEWBLACK X/
  ├── NEWBLACK_XApp.swift     # App entry point
  ├── Assets.xcassets/        # App assets
  ├── Common/                 # Shared app components
  ├── Composition/            # Dependency composition
  ├── Extensions/             # Swift extensions
  ├── Scenes/                 # App UI scenes
  │   ├── Home/               # Main tab view
  │   ├── Launches/           # Launches feature
  │   └── Rockets/            # Rockets feature
  └── Views/                  # Reusable UI components

Packages/
  ├── Core/                   # Core business logic
  └── Networking/             # Network layer
```

## Package Documentation

The app includes two main packages:

- [Core Package](/Packages/Core): Contains data models and business logic
    1. **[Entities](/Packages/Core/Sources/Entities/README.md)**: Defines the domain models representing SpaceX data, such as `Launch`, `Rocket`, and `Launchpad`.
    2. **[API](/Packages/Core/Sources/API/README.md)**: Contains the endpoints and services for interacting with the SpaceX API, including request and response handling.
    3. **[Shared](/Packages/Core/Sources/Shared/README.md)**: Provides shared utilities, protocols, and extensions used across the app and other packages.
- [Networking Package](/Packages/Networking/README.md): Handles API communication

### Networking Package

The Networking package provides a protocol-oriented Swift networking layer. See the Networking Documentation for detailed information about:

- Basic usage examples
- Request handling
- Authentication
- Error handling
- Best practices

### Core Package

The Core package contains the business logic and domain models. The package includes:

- Entities: Domain models representing SpaceX data
- API: Endpoints and services for the SpaceX API
- Shared: Shared utilities and protocols
- Mocks: Mock data for testing and development

## Getting Started

To run the application:

1. Clone the repository
2. Open the project in Xcode
3. Update signing configuration
4. Build and run on a simulator or device

For development with mocked data, run the Mocked scheme. Otherwise, running the Debug scheme will properly fetch API data.

## Technical Requirements

- iOS 18.0
- Swift 6.1
- Xcode 16.3