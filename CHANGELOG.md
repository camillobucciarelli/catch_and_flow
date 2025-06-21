# [0.1.0] - 2025-06-21

## Added

- Initial release of the catch_and_flow package
- Core `CustomError` class with `GenericError` and `ErrorFromException` implementations
- `Result` type for functional error handling with success/error pattern
- Safety handlers for different operation types:
  - `runSafetyFuture` and `runSafetyFutureNullable` for async operations
  - `runSafetyStream` and `runSafetyStreamNullable` for reactive streams
  - `runSafetySync` and `runSafetySyncNullable` for synchronous operations
- Extension methods:
  - `Future.when()` for callback-based future handling
  - `Stream.when()` for simplified stream subscription with callbacks
  - `Result.when()` for functional pattern matching
- Configurable logging system with:
  - Multiple log levels (debug, info, warning, error)
  - Custom logger interface
  - Helper functions for logging
- Complete API documentation with examples
