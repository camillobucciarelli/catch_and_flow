/// The catch_and_flow library provides utilities for error handling and flow control.
///
/// This library simplifies error handling in asynchronous operations like Futures and Streams,
/// and provides abstractions for handling, logging, and transforming errors in a type-safe way.
///
/// Key components:
/// - [CustomError]: Base class for all custom errors in the application
/// - [Result]: A record type representing either success with a value or failure with an error
/// - Error catchers: Functions that safely wrap operations to handle errors
/// - Extensions: Convenience methods for Futures, Streams and Results
/// - Logging: Structured logging with configurable log levels
library;

import 'catch_and_flow.dart';

export 'src/custom_error.dart';
export 'src/extensions/result_extension.dart';
export 'src/extensions/stream_extension.dart';
export 'src/extensions/future_extension.dart';
export 'src/logger.dart';
export 'src/error_catchers/future_error_catcher.dart';
export 'src/error_catchers/stream_error_catcher.dart';
export 'src/error_catchers/sync_error_catcher.dart';
export 'src/result.dart';

/// Main entry point for the catch_and_flow package.
///
/// Provides static methods to configure and access the logging functionality.
class CatchAndFlow {
  CatchAndFlow._(); // Private constructor to prevent instantiation

  static CatchAndFlowLogger? _logger;
  static LogLevel _logLevel = LogLevel.error; // Default log level is error

  /// Sets a custom logger for the catch_and_flow package.
  ///
  /// This must be called before using any of the log functions or running any safety operations.
  /// @param logger The custom logger implementation to use.
  static void setLogger(CatchAndFlowLogger? logger) {
    _logger = logger;
  }

  /// Sets the log level for the catch_and_flow package.
  ///
  /// Controls which log messages are displayed.
  /// @param level The log level to set.
  static void setLogLevel(LogLevel level) {
    _logLevel = level;
  }

  /// Gets the current log level.
  ///
  /// @return The current log level.
  static LogLevel getLogLevel() {
    return _logLevel;
  }

  /// Gets the current logger instance.
  ///
  /// @return The current logger implementation.
  static CatchAndFlowLogger? getLogger() {
    return _logger!;
  }
}
