import '../../catch_and_flow.dart';
import 'error_catcher.dart';

/// Type definition for a function that returns a [Future].
///
/// Used as a parameter type for functions that need to wrap future operations.
typedef FutureOperationFunction<T> = Future<T> Function();

/// Runs a future operation with safety handling.
///
/// Catches any exceptions and transforms them into [CustomError] objects.
///
/// @param operation The future operation to run safely.
/// @param onError Optional adapter to convert exceptions to custom errors.
/// @param logLevel Optional log level for error logging.
/// @return A [Future] that transforms errors into [CustomError] objects.
Future<T> runSafetyFuture<T>(
  FutureOperationFunction<T> operation, {
  CustomErrorAdapter? onError,
  LogLevel? logLevel,
}) async {
  try {
    return await operation();
  } catch (e) {
    return onErrorHandler(onError, logLevel)(e);
  }
}

/// Runs a future operation that may return null, with safety handling.
///
/// Catches any exceptions and returns null if an error occurs.
/// This is useful when you want to handle errors by returning null
/// instead of propagating the error.
///
/// @param operation The future operation to run safely.
/// @param logLevel Optional log level for error logging.
/// @return A [Future] that returns null on errors.
Future<T?> runSafetyFutureNullable<T>(
  FutureOperationFunction<T?> operation, {
  LogLevel? logLevel,
}) async {
  try {
    return await operation();
  } catch (e) {
    return errorToNullHandler(logLevel)(e);
  }
}
