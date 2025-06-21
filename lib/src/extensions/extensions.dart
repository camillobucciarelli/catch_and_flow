import '../../catch_and_flow.dart';

/// Callback function type for successful operations.
///
/// Takes a generic value of type [T] representing the result of an operation.
typedef SuccessCallback<T> = void Function(T);

/// Callback function type for error handling.
///
/// Takes a [CustomError] representing an error that occurred during an operation.
typedef ErrorCallback = void Function(CustomError);
