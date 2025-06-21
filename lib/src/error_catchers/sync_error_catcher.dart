import '../../catch_and_flow.dart';
import 'error_catcher.dart';

typedef SyncOperationFunction<T> = T Function();

/// Runs a synchronous operation with safety handling.
///
/// Catches any exceptions and transforms them into [CustomError] objects.
/// Returns a [Result] which contains either the successful value or a [CustomError].
///
/// @param operation The synchronous operation to run safely.
/// @param onError Optional adapter to convert exceptions to custom errors.
/// @param logLevel Optional log level for error logging.
/// @return A [Result<T>] containing either the operation result or a [CustomError].
Result<T> runSafetySync<T>(SyncOperationFunction<T> operation, {CustomErrorAdapter? onError, LogLevel? logLevel}) {
  try {
    return Results.success(operation());
  } catch (e) {
    return Results.error(onErrorHandler(onError, logLevel)(e));
  }
}

/// Runs a synchronous operation that may return null, with safety handling.
///
/// Catches any exceptions and returns a Result with null value if an error occurs.
/// @param operation The synchronous operation to run safely.
/// @param logLevel Optional log level for error logging.
/// @return A [Result<T?>] containing either the operation result (which may be null) or a [CustomError].
T? runSafetySyncNullable<T>(SyncOperationFunction<T> operation, {LogLevel? logLevel}) {
  try {
    return operation(); // Success result
  } catch (e) {
    return errorToNullHandler(logLevel)(e); // Error result with null value
  }
}
