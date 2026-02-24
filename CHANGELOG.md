# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.1] - 2026-02-24

### Changed

- Fixed stacktrace propagation

## [1.2.0] - 2026-02-23

### Added

- Added `getOrElse` to `ResultExtension` to provide a fallback value when the result is an error.
- Added `map` and `getOrElse` to `FutureExtension` for functional result transformation and fallback handling.
- Added `map` and `getOrElse` to `StreamExtension` for per-event transformation and error fallback emission.
- Added shared callback typedefs `MapSuccessCallback<T, R>` and `MapErrorCallback<R>` in `extensions.dart`.

### Changed

- Updated package version to `1.2.0`.
- Updated `equatable` dependency from `^2.0.7` to `^2.0.8`.
- Standardized extension imports to use the package barrel export (`catch_and_flow.dart`) where applicable.

## [1.1.0] - 2025-12-31

### Documentation

- Improved and clarified documentation for `Result` extensions (`result_extension.dart`), with clearer comments and usage notes.
- Added explanation in the docs on how to safely cast the contained value in `Result`.

### Changed

- Renamed the old `when` method on `Result` to `map` for consistency and clarity.
- Added a new `when` method to `Result`, now behaving like the `when` extension for `Future` and `Stream` (callback-based, for side effects).

## [1.0.9] - 2025-09-08

### Fixed

- Fixed bug in `runSafetyStream` where errors were not properly thrown to the stream
- Stream errors are now correctly propagated and can be intercepted by the `when` extension method

## [1.0.8] - 2025-09-04

### Improvements

- Error logs now print the stack trace for improved traceability

## [1.0.7] - 2025-09-04

### Updates

- Error logs now print the stack trace for improved traceability

## [1.0.6] - 2025-06-22

### Documentation Updates

- Enhanced documentation for synchronous error handling utilities
- Added detailed examples for `runSafetySync` and `runSafetySyncNullable` functions
- Added practical code examples for `SyncOperationFunction` usage
- Improved clarity and completeness of API documentation

## [1.0.5] - 2025-06-22

### Fixed

- Fixed type error in `FutureExtension.when` where a Future was incorrectly used as a CustomError

- Fixed critical bug in error handling and renamed `genericFromException` to `fromThrowable` for clarity
- Modified error handling to properly handle both Exception and Error types
- Improved robustness of error conversion in the error handling pipeline

## [1.0.4] - 2025-06-22

### Documentation Enhancements

- Improved documentation for error handling functions in `error_catcher.dart`
- Added comprehensive examples for `CustomErrorAdapter`, `onErrorHandler`, and `errorToNullHandler`
- Enhanced API documentation with practical use cases and implementation examples

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
