import '../../catch_and_flow.dart';

/// Type definition for a function that adapts any exception to a [CustomError].
///
/// This allows users to provide custom logic for converting exceptions into
/// specific [CustomError] subtypes.
typedef CustomErrorAdapter = CustomError Function(dynamic e);

/// Creates an error handler function for use with Future.catchError or similar.
///
/// @param error The callback to invoke with the transformed error.
/// @param logLevel Optional log level override for this specific error handler.
/// @return A function that handles errors by converting them to [CustomError] objects.
Function onErrorHandler(void Function(CustomError)? error, LogLevel? logLevel) => (dynamic e) {
  logError(e, logLevel);
  if (e is CustomError) {
    error?.call(e);
    return Future.error(e);
  }
  final customError = CustomError.genericFromException(e);
  error?.call(customError);
  return Future.error(customError);
};

/// Creates an error handler function that converts errors to null values.
///
/// This is useful for operations where you want to safely handle errors by
/// returning null instead of propagating the error.
///
/// @param logLevel Optional log level override for this specific error handler.
/// @return A function that handles errors by logging them and returning null.
Function errorToNullHandler(LogLevel? logLevel) => (dynamic e) {
  logError(e, logLevel);
  return null;
};
