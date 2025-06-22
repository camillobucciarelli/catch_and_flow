import 'package:equatable/equatable.dart';

/// Base class for all custom errors in the application.
///
/// [CustomError] is a sealed class that serves as the parent for all custom error types.
/// It extends Dart's built-in [Error] class and uses [EquatableMixin] to enable value
/// equality comparisons between errors with the same properties.
///
/// This abstract class provides a standardized way to handle errors throughout your application,
/// making it easier to categorize, track, and respond to different types of errors.
///
/// Example:
/// ```dart
/// // Create a custom error type by extending CustomError
/// class NetworkError extends CustomError {
///   NetworkError({String message = 'Network connection failed'})
///     : super(code: 'network-error', message: message);
/// }
///
/// // Using the custom error in error handling
/// try {
///   await fetchData();
/// } catch (e) {
///   throw NetworkError(message: 'Failed to fetch data: ${e.toString()}');
/// }
/// ```
abstract class CustomError extends Error with EquatableMixin {
  /// Creates a new [CustomError] with the specified code and message.
  ///
  /// @param code An error code identifier.
  /// @param message A human-readable error message describing what went wrong.
  CustomError({required this.code, required this.message});

  /// A unique code identifying the type of error.
  final String code;

  /// A descriptive message explaining the error.
  final String message;

  @override
  List<Object?> get props => [code, message];

  /// Creates a generic error from any exception.
  ///
  /// A convenience factory constructor to create a [GenericError] from an exception.
  static CustomError genericFromException(dynamic exception) =>
      ErrorFromException(exception: exception as Exception);
}

/// Represents a general error with a custom code and message.
///
/// Used for errors that don't fall into more specific categories. This class is useful
/// when you need to handle errors that aren't represented by specific error classes
/// in your application.
///
/// Example:
/// ```dart
/// // Creating a generic error
/// final error = GenericError(message: 'Something went wrong');
///
/// // Using in a Result
/// return Result.error(GenericError(message: 'Operation failed'));
/// ```
class GenericError extends CustomError {
  /// Creates a new [GenericError] with the specified message.
  ///
  /// @param code The error code, defaults to 'generic-error'.
  /// @param message A human-readable error message describing what went wrong.
  GenericError({super.code = 'generic-error', required super.message});
}

/// Converts a standard [Exception] into a [CustomError].
///
/// This class is used to wrap standard Dart exceptions in the custom error hierarchy,
/// allowing them to be handled uniformly with other custom errors in your application.
///
/// Example:
/// ```dart
/// try {
///   // Code that might throw a standard exception
/// } catch (e) {
///   if (e is Exception) {
///     return Result.error(ErrorFromException(exception: e));
///   }
///   // Handle other types of errors
/// }
/// ```
class ErrorFromException extends CustomError {
  /// Creates a new [ErrorFromException] wrapping the given exception.
  ///
  /// @param exception The exception to convert into a [CustomError].
  ErrorFromException({required Exception exception})
    : super(code: 'exception', message: exception.toString());
}
