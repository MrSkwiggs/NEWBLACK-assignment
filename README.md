# NEWBLACK X - Assignment

## Overview

NEWBLACK X is an iOS application that fetches and displays SpaceX launch and rocket information. The app uses a modern Swift architecture with SwiftUI, Swift Concurrency, and follows MVVM design patterns.

## Author
Dorian Grolaux

## Architecture

The application is structured using a modular architecture with the following components:

### Core Components

- **App Structure**: Tab-based navigation with two main sections - Launches and Rockets
- **Packages**:
  - Core: Contains data models and business logic
  - Networking: Handles API communication

### Design Patterns

- **MVVM**: View Models are separated from Views for better testability
- **Dependency Injection**: Uses [Factory](https://github.com/hmlongco/Factory) framework
- **Observable Objects**: Leverages Swift's `@Observable` for state management

## Features

### Launches

The Launches tab displays SpaceX launches with the following capabilities:

- **Launch List**: Shows all SpaceX launches with pagination support
- **Date Range Filtering**: Filter launches by date ranges
- **Launch Details**: View detailed information about each launch
- **Related Content**: Access rocket and launchpad information from a launch

### Rockets

The Rockets tab displays information about SpaceX rockets:

- **Rocket List**: Displays all SpaceX rockets with pagination
- **Rocket Details**: Shows comprehensive specifications for each rocket
- **Engine Information**: Detailed engine specifications with ISP details

## UI Components

The app includes several reusable UI components:

- `AsyncGallery`: Image gallery with async loading
- `StickyHeaderList`: List with scaling sticky header
- `DateRangeFilter`: UI for selecting date ranges
- `WebView`: In-app web browser for external links

## Data Flow

1. **View Model Initialization**: Factory creates view models with appropriate dependencies
2. **Data Loading**: View models request data from providers
3. **State Management**: `ModelState` tracks loading, success, and error states
4. **UI Updates**: SwiftUI views react to state changes

## Testing

The application includes both unit tests and UI tests:

- **Unit Tests**: Tests for view models and model state
- **UI Tests**: Integration tests for key user flows using the Page Object pattern

## Debug Features

- **Launch Arguments**: Configure mock behavior with launch arguments
- **Mock Providers**: Substitute real API calls with predictable responses
- **Mock Durations**: Simulate network delays for testing loading states

## Resource Management

- Images are loaded asynchronously using `AsyncImage`
- Pagination is used to minimize memory usage and network traffic

## External Resources

- SpaceX API for launch and rocket data
- Wikipedia links for additional information
- YouTube links for launch videos

## Getting Started

To run the application:

1. Clone the repository
2. Open the project in Xcode
3. Build and run on a simulator or device

For development with mocked data, you can add launch arguments in the scheme editor.

## Technical Requirements

- iOS 16.0+
- Swift 5.9+
- Xcode 15.0+