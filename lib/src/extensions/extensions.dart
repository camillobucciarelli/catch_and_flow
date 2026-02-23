import '../../catch_and_flow.dart';

/// Callback function type for successful operations.
///
/// Takes a generic value of type [T] representing the result of an operation.
typedef SuccessCallback<T> = void Function(T value);

/// Callback function type for error handling.
///
/// Takes a [CustomError] representing an error that occurred during an operation.
typedef ErrorCallback = void Function(CustomError error);

/// Callback per la trasformazione di un valore di successo in map.
typedef MapSuccessCallback<T, R> = R Function(T value);

/// Callback per la trasformazione di un errore in map.
typedef MapErrorCallback<R> = R Function(CustomError error);
