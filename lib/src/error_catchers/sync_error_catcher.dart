import '../../catch_and_flow.dart';
import 'error_catcher.dart';

/// Type definition for a synchronous function that returns a value of type [T].
///
/// Used as a parameter type for functions that need to wrap synchronous operations.
/// The function takes no parameters and returns a value of type [T].
///
/// Example:
/// ```dart
/// // Creating a function that matches SyncOperationFunction<int>
/// SyncOperationFunction<int> calculateTotal = () {
///   return items.fold(0, (sum, item) => sum + item.price);
/// };
///
/// // Using it with runSafetySync
/// Result<int> totalResult = runSafetySync(calculateTotal);
/// ```
typedef SyncOperationFunction<T> = T Function();

/// Runs a synchronous operation with safety handling.
///
/// Catches any exceptions and transforms them into [CustomError] objects.
/// Returns a [Result] which contains either the successful value or a [CustomError].
/// This is particularly useful for operations that might throw exceptions but where
/// you prefer to handle errors in a functional way.
///
/// Example:
/// ```dart
/// Result<int> divideNumbers(int a, int b) {
///   return runSafetySync(
///     () => a ~/ b,
///     onError: (e) {
///       if (e is IntegerDivisionByZeroException) {
///         return DivisionError(message: 'Cannot divide by zero');
///       }
///       return null; // Use default error handling
///     },
///     logLevel: LogLevel.error
///   );
/// }
///
/// // Using the result
/// divideNumbers(10, 2).when(
///   success: (result) => print('Result: $result'),
///   error: (error) => print('Error: ${error.message}')
/// );
/// ```
///
/// @param operation The synchronous operation to run safely.
/// @param onError Optional adapter to convert exceptions to custom errors.
/// @param logLevel Optional log level for error logging.
/// @return A [Result<T>] containing either the operation result or a [CustomError].
Result<T> runSafetySync<T>(
  SyncOperationFunction<T> operation, {
  CustomErrorAdapter? onError,
  LogLevel? logLevel,
}) {
  try {
    return Results.success(operation());
  } catch (e, st) {
    return Results.error(
      onErrorHandler(e, onError: onError, logLevel: logLevel, stackTrace: st),
    );
  }
}

/// Runs a synchronous operation that may return null, with safety handling.
///
/// Catches any exceptions and returns null if an error occurs. This is useful when
/// you want to handle errors by returning null rather than propagating exceptions
/// or working with Result types. This approach is ideal for cases where a null value
/// is an acceptable fallback.
///
/// Example:
/// ```dart
/// String? getUserName(int userId) {
///   return runSafetySyncNullable(
///     () {
///       final user = userRepository.getUser(userId);
///       if (user == null) return null;
///       return user.name;
///     },
///     logLevel: LogLevel.warning
///   );
/// }
///
/// // Using the result
/// final name = getUserName(123);
/// if (name != null) {
///   print('User name: $name');
/// } else {
///   print('User not found or error occurred');
/// }
/// ```
///
/// @param operation The synchronous operation to run safely.
/// @param logLevel Optional log level for error logging.
/// @return The operation result if successful, or null if an error occurs.
T? runSafetySyncNullable<T>(
  SyncOperationFunction<T> operation, {
  LogLevel? logLevel,
}) {
  try {
    return operation(); // Success result
  } catch (e, st) {
    return errorToNullHandler(
      e,
      logLevel: logLevel,
      stackTrace: st,
    ); // Error result with null value
  }
}
