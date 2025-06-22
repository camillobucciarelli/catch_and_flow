# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.3] - 2025-06-22

### Documentation Improvements

- Improved documentation for the `StreamExtension` class
- Added detailed examples to the `when` method documentation
- Enhanced API documentation with more context and use cases

## [1.0.2] - 2025-06-21

### Enhanced

- Improved documentation for the `CustomError` class and its subclasses
- Added comprehensive examples to class documentation

## [1.0.1] - 2025-06-21

### Changes

- Updated package dependencies
- Minor code improvements

## [1.0.0] - 2025-06-21

### Added

- First stable release of the catch_and_flow package
- Core `CustomError` class with `GenericError` and `ErrorFromException` implementations
- `Result` type for functional error handling with success/error pattern
- Safety handlers for different operation types:
  - `runSafetyFuture` and `runSafetyFutureNullable` for async operations
  - `runSafetyStream` and `runSafetyStreamNullable` for reactive streams
  - `runSafetySync` and `runSafetySyncNullable` for synchronous operations
- Extension methods:
  - `Future.when()` for callback-based future handling with progress, success, and error callbacks
  - `Stream.when()` for simplified stream subscription with progress, success, and error callbacks
  - `Result.when()` for functional pattern matching
- Configurable logging system with:
  - Multiple log levels (debug, info, warning, error, none)
  - Custom logger interface for easy integration with existing logging solutions
  - Helper functions for context-aware logging
- Complete API documentation with comprehensive examples
- Optimized error handling with minimal boilerplate code
- Full compatibility with Flutter and Dart projects
- Reliable error transformation and propagation

### Changed

- Improved documentation with detailed usage examples for all components
- Enhanced type safety across all APIs
- Optimized internal error handling mechanisms

### Removed

- Removed experimental features to ensure stability for 1.0.0 release

## [0.1.0] - 2025-06-20

### Initial Release

- Initial beta release of the catch_and_flow package
- Core `CustomError` class with `GenericError` and `ErrorFromException` implementations
- `Result` type for functional error handling with success/error pattern
- Basic safety handlers for different operation types
- Extension methods for Future, Stream and Result types
- Configurable logging system
- Initial API documentation with examples
