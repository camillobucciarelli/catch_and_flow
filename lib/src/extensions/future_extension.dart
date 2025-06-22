import 'dart:async';

import 'package:flutter/material.dart';

import '../../catch_and_flow.dart';
import 'extensions.dart';

/// Extensions on [Future] to provide simplified error handling and flow control.
extension FutureExtension<T> on Future<T> {
  /// Processes the result of this future with callback-based flow control.
  ///
  /// Provides a convenient way to handle a future's success and error cases with callbacks.
  ///
  /// - [progress] is called immediately when the method is invoked
  /// - [success] is called if the future completes successfully
  /// - [error] is called if the future completes with an error
  /// - [logLevel] optional log level for this specific future operation
  ///
  /// Returns a [Future<void>] that completes when all callbacks have been processed.
  Future<void> when({
    VoidCallback? progress,
    SuccessCallback<T>? success,
    ErrorCallback? error,
    LogLevel? logLevel,
  }) async {
    logDebug('FutureExtension.when: Operation started', logLevel);
    progress?.call();
    return then((value) {
      logDebug(
        'FutureExtension.when: Operation completed successfully with value: $value',
        logLevel,
      );
      success?.call(value);
    }).catchError((e) {
      logDebug(
        'FutureExtension.when: Operation failed with error: $e',
        logLevel,
      );
      final customError = e is CustomError ? e : CustomError.fromThrowable(e);
      error?.call(customError);
    });
  }
}
