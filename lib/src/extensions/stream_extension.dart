import 'dart:async';

import 'package:flutter/material.dart';

import '../error_catchers/error_catcher.dart';
import '../logger.dart';
import 'extensions.dart';

/// Extensions on [Stream] to provide simplified error handling and flow control.
extension StreamExtension<T> on Stream<T> {
  /// Processes the emissions of this stream with callback-based flow control.
  ///
  /// Provides a convenient way to handle a stream's success and error events with callbacks.
  ///
  /// - [progress] is called immediately when the method is invoked
  /// - [success] is called for each value emitted by the stream
  /// - [error] is called if the stream emits an error
  /// - [logLevel] optional log level for this specific stream operation
  ///
  /// Returns a [StreamSubscription] that can be used to control the subscription.
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
      return onErrorHandler(error, logLevel)(e);
    }

    final stream = handleError(errorHandlerWithLogging);

    // Create a modified success callback that includes logging
    void successWithLogging(T value) {
      logDebug('StreamExtension.when: Stream emitted value: $value', logLevel);
      success?.call(value);
    }

    return stream.listen(successWithLogging);
  }
}
