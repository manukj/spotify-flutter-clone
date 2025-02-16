# Spotify Flutter App

A Flutter application that implements Spotify's search functionality with a clean, modern UI.

## Architecture

This app follows Clean Architecture principles with a feature-first organization:

```
/lib
├── core/                  # App-wide shared code
│   ├── config/           # Environment configuration
│   ├── di/               # Dependency injection setup
│   ├── error/            # Custom exceptions
│   ├── network/          # Network handling (Dio setup, interceptors)
│   ├── theme/            # App theming
│   └── utils/            # Utilities (logger, debouncer)
│
└── features/
    └── search/           # Search feature module
        ├── data/         # Data layer
        │   ├── datasources/    # Remote data sources
        │   ├── models/         # Data models with JSON parsing
        │   └── repositories/   # Repository implementations
        │
        ├── domain/            # Business logic layer
        │   ├── entities/      # Core business objects
        │   ├── repositories/  # Repository interfaces
        │   └── usecases/      # Use cases
        │
        └── presentation/      # UI layer
            ├── controllers/   # GetX controllers
            ├── pages/         # Screens
            └── widgets/       # UI components
```

## State Management

The app uses GetX for state management and dependency injection:

- **SearchController**: Central controller managing search state
- **Reactive State Variables**:
  ```dart
  final isLoading = false.obs;
  final query = ''.obs;
  final artistsResponse = Rxn<ArtistsResponse>();
  final albumsResponse = Rxn<AlbumsResponse>();
  final error = Rxn<String>();
  final isArtistSelected = true.obs;
  final isAlbumSelected = false.obs;
  ```
- **Reactive UI**: Widgets use `Obx` for automatic rebuilds
- **Debounced Search**: Optimized search with debouncing

## Key Features

### 1. Dependency Injection
- GetX-based dependency injection
- Centralized setup in `DependencyInjection` class
- Easy testing with dependency mocking

### 2. Network Layer
- Dio for HTTP requests
- Custom interceptors for authentication and error handling
- Spotify API integration
- Proper error handling and retry mechanisms

### 3. Error Handling
- Custom exceptions for different error scenarios
- Centralized error handling in interceptors
- User-friendly error messages
- Proper error state management

### 4. UI Components
- Modern, responsive design
- Sliver-based scrolling implementation
- Grid view for albums
- List view for artists
- Custom search bar and filter chips
- Proper loading and error states

### 5. Testing
- Comprehensive widget tests
- Mocking with mocktail
- Controller testing
- Network layer testing

## Getting Started

### Prerequisites
- Flutter SDK (^3.6.1)
- Dart SDK (^3.6.1)
- A Spotify Developer Account
- Make (for running Makefile commands)

### Setup
1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/spotify_flutter.git
   ```

2. Setup the project (clean, get dependencies, and generate code)
   ```bash
   make setup
   ```

3. Create a `.env` file in the root directory with your Spotify credentials:
   ```
   SPOTIFY_CLIENT_ID=your_client_id
   SPOTIFY_CLIENT_SECRET=your_client_secret
   ```

### Available Make Commands

```bash
# Development
make run-dev          # Run app in development mode
make run-prod         # Run app in production mode

# Testing
make test            # Run all tests
make test-watch      # Run tests in watch mode
make coverage        # Generate and view coverage report

# Code Generation
make build_runner    # Run build_runner once
make watch_runner    # Run build_runner in watch mode

# Formatting and Linting
make format          # Format code and apply fixes
make lint            # Run flutter analyze

# Cleaning
make clean           # Clean project artifacts

# Building
make build-apk       # Build Android APK
make build-ios       # Build iOS app

# Help
make help           # Show all available commands
```

## Dependencies

- `get`: ^4.7.2 - State management and dependency injection
- `dio`: ^5.8.0+1 - HTTP client
- `json_annotation`: ^4.9.0 - JSON serialization
- `flutter_dotenv`: ^5.2.1 - Environment configuration
- `get_storage`: ^2.1.1 - Local storage
- `logger`: ^2.5.0 - Logging

## Development Dependencies

- `build_runner`: ^2.4.15 - Code generation
- `json_serializable`: ^6.9.4 - JSON serialization
- `mocktail`: ^1.0.4 - Mocking for tests
- `flutter_lints`: ^5.0.0 - Linting

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Format and lint your code:
   ```bash
   make format
   make lint
   ```
4. Run tests:
   ```bash
   make test
   make coverage
   ```
5. Commit your changes (`git commit -m 'Add some amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
