import 'dart:async';

import '../../catch_and_flow.dart';
import 'error_catcher.dart';

/// Type definition for a function that returns a [Stream].
///
/// Used as a parameter type for functions that need to wrap stream operations.
typedef StreamOperationFunction<T> = Stream<T> Function();

/// Runs a stream operation with safety handling.
///
/// Transforms any errors in the stream into [CustomError] objects.
///
/// @param operation The stream operation to run safely.
/// @param onError Optional adapter to convert exceptions to custom errors.
/// @param logLevel Optional log level for error logging.
/// @return A broadcast stream that transforms errors into [CustomError] objects.
Stream<T> runSafetyStream<T>(
  StreamOperationFunction<T> operation, {
  CustomErrorAdapter? onError,
  LogLevel? logLevel,
}) {
  return operation().asBroadcastStream().handleError((e, st) {
    return onErrorHandler(onError, logLevel)(e);
  });
}

/// Runs a stream operation that may return nullable values, with safety handling.
///
/// Catches any errors in the stream and emits `null` instead of the error.
/// This is useful when you want to handle errors gracefully without breaking the stream.
///
/// @param operation The stream operation to run safely.
/// @param logLevel Optional log level for error logging.
/// @return A broadcast stream that emits null values on errors instead of breaking the stream.
Stream<T?> runSafetyStreamNullable<T>(
  StreamOperationFunction<T> operation, {
  LogLevel? logLevel,
}) {
  // Create a StreamController to manage the output stream
  final controller = StreamController<T?>.broadcast();

  // Subscribe to the original stream
  final subscription = operation().listen(
    // Pass through normal values
    (data) => controller.add(data),
    // On error, log it and emit null
    onError: (dynamic error, StackTrace stackTrace) {
      // Emit null instead of the error
      controller.add(errorToNullHandler(logLevel)(error));
    },
    // Close the controller when the source stream is done
    onDone: () => controller.close(),
  );

  // Close the subscription when the controller is closed
  controller.onCancel = () => subscription.cancel();

  return controller.stream;
}
