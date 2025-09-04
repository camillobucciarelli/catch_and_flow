import '../../catch_and_flow.dart';

/// Type definition for a function that adapts any exception to a [CustomError].
///
/// This allows users to provide custom logic for converting exceptions into
/// specific [CustomError] subtypes. By using this adapter, you can define how
/// different exceptions should be mapped to your application's error types.
///
/// Example:
/// ```dart
/// // Creating a custom error adapter
/// CustomErrorAdapter myAdapter = (dynamic e) {
///   if (e is TimeoutException) {
///     return NetworkError(message: 'Connection timed out');
///   } else if (e is SocketException) {
///     return NetworkError(message: 'Network connection failed');
///   }
///   return GenericError(message: e.toString());
/// };
/// ```
typedef CustomErrorAdapter = dynamic Function(dynamic e);

/// Creates an error handler function for use with Future.catchError or similar asynchronous error handling mechanisms.
///
/// This function creates an error handler that logs the error and transforms it into a [CustomError] object.
/// If the provided error is already a [CustomError], it is passed through unchanged.
/// Otherwise, it is converted using either the provided adapter or the default conversion.
///
/// Example:
/// ```dart
/// Future<void> fetchData() async {
///   try {
///     final data = await api.getData();
///     return data;
///   } catch (e) {
///     return Future.error(e).catchError(onErrorHandler((e) {
///       if (e is HttpException) {
///         return NetworkError(message: 'Failed to fetch data: ${e.message}');
///       }
///       return null; // Use default error handling
///     }, LogLevel.error));
///   }
/// }
/// ```
///
/// @param onError The callback to invoke with the transformed error.
/// @param logLevel Optional log level override for this specific error handler.
/// @return A function that handles errors by converting them to [CustomError] objects.
CustomError onErrorHandler(
  dynamic e, {
  CustomErrorAdapter? onError,
  LogLevel? logLevel,
}) {
  logError(e, logLevel, e, StackTrace.current);
  final error = onError?.call(e) ?? e;
  if (error is CustomError) {
    return error;
  }
  return CustomError.fromThrowable(error);
}

/// Creates an error handler function that converts errors to null values.
///
/// This is useful for operations where you want to safely handle errors by
/// returning null instead of propagating the error. This approach allows for
/// graceful fallback behavior in cases where the operation might fail but
/// the application can continue with a null value.
///
/// Example:
/// ```dart
/// Future<User?> getUser() async {
///   try {
///     return await userService.fetchUser(userId);
///   } catch (e) {
///     // Convert any errors to null using the handler
///     return Future.error(e).catchError(errorToNullHandler(LogLevel.warning));
///   }
/// }
///
/// // Using the function
/// final user = await getUser();
/// if (user != null) {
///   // Process user
/// } else {
///   // Handle the null case gracefully
/// }
/// ```
///
/// @param logLevel Optional log level override for this specific error handler.
/// @return A function that handles errors by logging them and returning null.
T? errorToNullHandler<T>(dynamic e, {LogLevel? logLevel}) {
  logError(e, logLevel, e, StackTrace.current);
  return null;
}
