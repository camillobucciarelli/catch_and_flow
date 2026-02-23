import 'dart:async';

import 'package:flutter/material.dart';

import '../../catch_and_flow.dart';
import 'extensions.dart';

/// Extensions on [Stream] to provide simplified error handling and flow control.
///
/// This extension adds utility methods to simplify working with Dart streams by
/// providing a more fluent API for handling stream events and errors.
///
/// With these extensions, you can transform complex stream handling code into more
/// concise and readable patterns that follow functional programming principles.
extension StreamExtension<T> on Stream<T> {
  /// Processes the emissions of this stream with callback-based flow control.
  ///
  /// Provides a convenient way to handle a stream's success and error events with callbacks,
  /// reducing the boilerplate needed for common stream operations.
  ///
  /// - [progress] is called immediately when the method is invoked, useful for showing loading indicators
  /// - [success] is called for each value emitted by the stream
  /// - [error] is called if the stream emits an error
  /// - [logLevel] optional log level for this specific stream operation
  ///
  /// Returns a [StreamSubscription] that can be used to control the subscription.
  ///
  /// Example:
  /// ```dart
  /// Stream<int> numberStream = Stream.periodic(
  ///   const Duration(seconds: 1),
  ///   (count) => count + 1
  /// ).take(5);
  ///
  /// final subscription = numberStream.when(
  ///   progress: () => showLoadingIndicator(),
  ///   success: (number) => updateUI(number),
  ///   error: (error) => showErrorMessage(error.toString()),
  ///   logLevel: LogLevel.debug
  /// );
  ///
  /// // Later, when done with the stream
  /// subscription.cancel();
  /// ```
  StreamSubscription<T> when({
    VoidCallback? progress,
    SuccessCallback<T>? success,
    ErrorCallback? error,
    LogLevel? logLevel,
  }) {
    logDebug('StreamExtension.when: Subscription started', logLevel);
    progress?.call();

    // Create a modified error handler that includes logging
    errorHandlerWithLogging(dynamic e, StackTrace? st) {
      logDebug('StreamExtension.when: Stream error occurred: $e', logLevel);
      error?.call(e);
    }

    final stream = handleError(errorHandlerWithLogging);

    // Create a modified success callback that includes logging
    void successWithLogging(T value) {
      logDebug('StreamExtension.when: Stream emitted value: $value', logLevel);
      success?.call(value);
    }

    return stream.listen(successWithLogging);
  }
  /// Mappa ogni emissione di questo Stream in un valore di tipo [R] usando due callback:
  /// - [success]: chiamata per ogni valore emesso
  /// - [error]: chiamata per ogni errore emesso
  ///
  /// Restituisce uno Stream&lt;R&gt; con i valori prodotti dalle callback.
  Stream<R> map<R>({
    required MapSuccessCallback<T, R> success,
    required MapErrorCallback<R> error,
  }) {
    return transform(
      StreamTransformer<T, R>.fromHandlers(
        handleData: (data, sink) {
          sink.add(success(data));
        },
        handleError: (e, st, sink) {
          final customError = e is CustomError
              ? e
              : CustomError.fromThrowable(e);
          sink.add(error(customError));
        },
      ),
    );
  }

  /// Restituisce uno stream che emette il valore di successo oppure il valore di fallback fornito dalla callback in caso di errore.
  Stream<T> getOrElse(MapErrorCallback<T> orElse) {
    return transform(
      StreamTransformer<T, T>.fromHandlers(
        handleData: (data, sink) {
          sink.add(data);
        },
        handleError: (e, st, sink) {
          final customError = e is CustomError
              ? e
              : CustomError.fromThrowable(e);
          sink.add(orElse(customError));
        },
      ),
    );
  }
}
