import 'custom_error.dart';

/// Represents a result that can either be a success value of type [T] or a [CustomError].
///
/// Uses Dart's record feature to represent this union type in a lightweight way.
/// The record is in the form of `(CustomError? error, T? value)` where exactly one
/// of the fields is non-null.
typedef Result<T> = (CustomError? error, T? value);

/// Factory methods for creating [Result] objects.
class Results {
  /// Private constructor to prevent instantiation.
  ///
  /// This class only provides static factory methods and should not be instantiated.
  Results._();

  /// Creates a success result with the given value.
  static Result<T> success<T>(T value) => (null, value);

  /// Creates an error result with the given error.
  static Result<T> error<T>(CustomError error) => (error, null);
}
