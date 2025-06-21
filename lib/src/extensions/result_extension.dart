import '../../catch_and_flow.dart';

/// Extension methods for the [Result] type.
extension ResultExtension<T> on Result<T> {
  /// Whether this result represents a success (has a value and no error).
  ///
  /// Returns `true` if this result contains a value and no error.
  bool get isSuccess => $1 == null && $2 != null;

  /// Whether this result represents a failure (has an error and no value).
  ///
  /// Returns `true` if this result contains an error and no value.
  bool get isFailure => $1 != null && $2 == null;

  /// Returns the success value if this is a success, otherwise returns null.
  ///
  /// This is a convenient way to access the value directly, but requires null checking.
  /// Consider using [when] for more type-safe access.
  T? get valueOrNull => $2;

  /// Returns the error if this is a failure, otherwise returns null.
  ///
  /// This is a convenient way to access the error directly, but requires null checking.
  /// Consider using [when] for more type-safe access.
  CustomError? get errorOrNull => $1;

  /// Transforms the result using two callback functions.
  ///
  /// This is the recommended way to handle both success and failure cases
  /// in a type-safe manner without requiring null checks.
  ///
  /// @param fnSuccess Function to execute if the result is a success.
  /// @param fnFailure Function to execute if the result is a failure.
  /// @return The value returned by either fnSuccess or fnFailure.
  R when<R>(
    R Function(T value) fnSuccess,
    R Function(CustomError error) fnFailure,
  ) {
    if (isSuccess) {
      return fnSuccess($2 as T);
    } else {
      return fnFailure($1!);
    }
  }
}
