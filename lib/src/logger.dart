import '../catch_and_flow.dart';

/// Enumeration defining the available log levels.
///
/// The log levels are ordered from least severe to most severe:
/// - [none] - No logging
/// - [debug] - Detailed information for debugging
/// - [info] - General information about application progress
/// - [warning] - Potentially harmful situations
/// - [error] - Error events that might still allow the application to continue
enum LogLevel {
  /// No logs will be shown.
  none,

  /// Debug information, typically only useful during development.
  debug,

  /// General information about application progress.
  info,

  /// Potentially harmful situations.
  warning,

  /// Error events that might still allow the application to continue.
  error,
}

/// An abstract interface for logging functionality in the catch_and_flow package.
///
/// This class allows users to implement custom logging behavior by extending this class
/// and providing their own implementations of the logging methods.
abstract class CatchAndFlowLogger {
  /// Creates a new instance of a [CatchAndFlowLogger].
  ///
  /// Implementations should provide their own constructor logic if needed.
  /// This abstract class doesn't enforce any specific constructor implementation.
  const CatchAndFlowLogger();
  /// Logs an error message with optional error object and stack trace.
  ///
  /// @param message The error message or object to log.
  /// @param error Optional error object providing additional information.
  /// @param stackTrace Optional stack trace associated with the error.
  void logError(dynamic message, [dynamic error, StackTrace? stackTrace]);

  /// Logs a warning message.
  ///
  /// @param message The warning message to log.
  void logWarning(dynamic message);

  /// Logs an informational message.
  ///
  /// @param message The information message to log.
  void logInfo(dynamic message);

  /// Logs a debug message.
  ///
  /// @param message The debug message to log.
  void logDebug(dynamic message);
}

/// Helper function to log errors.
///
/// Does nothing if no logger has been set or if the log level is set to [LogLevel.none].
/// @param message The error message or object to log.
/// @param error Optional error object providing additional information.
/// @param stackTrace Optional stack trace associated with the error.
void logError(
  dynamic message, [
  LogLevel? logLevel,
  dynamic error,
  StackTrace? stackTrace,
]) {
  if ((logLevel != null && logLevel.index >= LogLevel.error.index) ||
      CatchAndFlow.getLogLevel().index >= LogLevel.error.index) {
    CatchAndFlow.getLogger()?.logError(message, error, stackTrace);
  }
}

/// Helper function to log warnings.
///
/// Does nothing if no logger has been set or if the log level is higher than [LogLevel.warning].
/// @param message The warning message to log.
void logWarning(dynamic message, [LogLevel? logLevel]) {
  if ((logLevel != null && logLevel.index >= LogLevel.warning.index) ||
      CatchAndFlow.getLogLevel().index >= LogLevel.warning.index) {
    CatchAndFlow.getLogger()?.logWarning(message);
  }
}

/// Helper function to log informational messages.
///
/// Does nothing if no logger has been set or if the log level is higher than [LogLevel.info].
/// @param message The information message to log.
void logInfo(dynamic message, [LogLevel? logLevel]) {
  if ((logLevel != null && logLevel.index >= LogLevel.info.index) ||
      CatchAndFlow.getLogLevel().index >= LogLevel.info.index) {
    CatchAndFlow.getLogger()?.logInfo(message);
  }
}

/// Helper function to log debug messages.
///
/// Does nothing if no logger has been set or if the log level is higher than [LogLevel.debug].
/// @param message The debug message to log.
void logDebug(dynamic message, [LogLevel? logLevel]) {
  if ((logLevel != null && logLevel.index >= LogLevel.debug.index) ||
      CatchAndFlow.getLogLevel().index >= LogLevel.debug.index) {
    CatchAndFlow.getLogger()?.logDebug(message);
  }
}
