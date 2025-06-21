# Catch And Flow

A Flutter package for streamlined error handling, logging, and asynchronous flow control. Simplify your error management with type-safe custom errors and structured logging.

## Features

- Unified error handling for Futures and Streams
- Type-safe custom error hierarchy
- Structured logging with configurable log levels
- Simple API for handling async operations
- Extension methods for cleaner error handling
- Result type for functional error handling

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  catch_and_flow: ^1.0.0
```

Configure a logger before using the package:

```dart
import 'package:catch_and_flow/catch_and_flow.dart';

class MyCustomLogger implements CatchAndFlowLogger {
  @override
  void logDebug(dynamic message) => print('DEBUG: $message');
  
  @override
  void logError(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    print('ERROR: $message');
    if (error != null) print('   $error');
    if (stackTrace != null) print('   $stackTrace');
  }
  
  @override
  void logInfo(dynamic message) => print('INFO: $message');
  
  @override
  void logWarning(dynamic message) => print('WARN: $message');
}

void main() {
  // Set up the logger
  CatchAndFlow.setLogger(MyCustomLogger());
  // Set the log level (optional, defaults to LogLevel.error)
  CatchAndFlow.setLogLevel(LogLevel.debug);
  
  runApp(MyApp());
}
```

## Usage

### Working with Futures

#### Basic future error handling

```dart
import 'package:catch_and_flow/catch_and_flow.dart';

Future<User> fetchUser() async {
  return runSafetyFuture(() async {
    final response = await http.get(Uri.parse('https://api.example.com/user'));
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw GenericError(
        code: 'api-error',
        message: 'Failed to fetch user: ${response.statusCode}'
      );
    }
  });
}
```

#### Using the Future extension with `when`

```dart
void loadUser() {
  fetchUser().when(
    // Called immediately when the operation starts
    progress: () => showLoadingIndicator(),
    // Called when the Future completes successfully
    success: (user) => showUserProfile(user),
    // Called when the Future completes with an error
    error: (error) => showErrorMessage(error.message),
    // Optional: Override the log level for this specific operation
    logLevel: LogLevel.debug,
  );
}
```

#### Future with custom error transformation

```dart
Future<User> fetchUserWithCustomErrors() {
  return runSafetyFuture(
    () async => /* API call that might throw */,
    onError: (e) {
      if (e is SocketException) {
        return NetworkError(
          statusCode: 0, 
          message: 'No internet connection'
        );
      } else if (e is HttpException && e.toString().contains('401')) {
        return AuthenticationError(message: 'Unauthorized');
      }
      return GenericError(message: e.toString());
    },
    logLevel: LogLevel.warning, // Optional: custom log level
  );
}
```

#### Future with null on error

```dart
// Returns the user or null if an error occurs
Future<User?> fetchUserSafe() async {
  return runSafetyFutureNullable(() async {
    return await api.getUser();
  }, logLevel: LogLevel.info); // Optional: custom log level
}
```

### Working with Streams

#### Basic stream error handling

```dart
Stream<String> getStatusUpdates() {
  return runSafetyStream(() => 
    _api.statusUpdates.map((response) {
      if (response.isValid) {
        return response.message;
      } else {
        throw GenericError(
          code: 'invalid-status',
          message: 'Received invalid status update'
        );
      }
    })
  );
}
```

#### Using the Stream extension with `when`

```dart
StreamSubscription<String> subscribeToUpdates() {
  return getStatusUpdates().when(
    // Called immediately when subscribing to the stream
    progress: () => showConnectingIndicator(),
    // Called for each value emitted by the stream
    success: (update) {
      showUpdate(update);
      saveUpdateToHistory(update);
    },
    // Called when the stream emits an error
    error: (error) {
      showErrorOverlay(error.message);
      reconnectAfterDelay();
    },
    // Optional: Override the log level for this specific subscription
    logLevel: LogLevel.debug,
  );
}
```

#### Stream with null on error

```dart
// For streams, emits null instead of errors
Stream<Update?> getUpdatesWithoutBreaking() {
  return runSafetyStreamNullable(() {
    return api.updates;
  }, logLevel: LogLevel.debug); // Optional: custom log level
}
```

### Working with Synchronous Operations

#### Basic synchronous error handling with Result

```dart
Result<User> getUserSync(String userId) {
  return runSafetySync(() {
    // Synchronous operation that might throw
    if (_userCache.containsKey(userId)) {
      return _userCache[userId]!;
    } else {
      throw GenericError(
        code: 'user-not-found',
        message: 'User $userId not found in cache'
      );
    }
  });
}
```

#### Using the Result type with `when`

```dart
void displayUserInfo(String userId) {
  final userResult = getUserSync(userId);
  
  // Using the when method for functional pattern matching
  userResult.when(
    (user) => showUserData(user), // Success case
    (error) => showError(error.message) // Error case
  );
}
```

#### Accessing Result properties directly

```dart
void processUserResult(Result<User> userResult) {
  // Check if the operation was successful
  if (userResult.isSuccess) {
    final user = userResult.valueOrNull!;
    showUserData(user);
    updateLastAccessTime();
  } else {
    // Handle the error case
    final error = userResult.errorOrNull!;
    showError(error.message);
    logFailedAttempt(error.code);
  }
}
```

#### Synchronous operation with null on error

```dart
User? getUserSafeSync(String userId) {
  return runSafetySyncNullable(() {
    return _userRepository.getUserById(userId);
  }, logLevel: LogLevel.warning);
}
```

### Creating custom errors

```dart
import 'package:catch_and_flow/catch_and_flow.dart';

class AuthenticationError extends CustomError {
  AuthenticationError({required String message})
    : super(code: 'auth-error', message: message);
}

class NetworkError extends CustomError {
  final int statusCode;
  
  NetworkError({required this.statusCode, required String message})
    : super(code: 'network-error', message: message);
    
  @override
  List<Object?> get props => [...super.props, statusCode];
}
```

## Advanced usage

### Combining different error handlers

You can combine different error handling approaches depending on your needs:

```dart
Future<void> loadAndProcessData() async {
  // First, try to get the user from cache synchronously
  final cachedUserResult = getUserSync(currentUserId);
  
  if (cachedUserResult.isSuccess) {
    // We have a cached user, use it immediately
    processUser(cachedUserResult.valueOrNull!);
  } else {
    // No cached user, fetch from network with proper error handling
    fetchUser().when(
      progress: () => showLoading(true),
      success: (user) {
        showLoading(false);
        processUser(user);
        // Cache the user for next time
        _userCache[user.id] = user;
      },
      error: (error) {
        showLoading(false);
        showError('Failed to load user: ${error.message}');
      }
    );
  }
  
  // In parallel, start listening to updates
  getStatusUpdates().when(
    success: (update) => processUpdate(update),
    error: (error) => logWarning('Update error: ${error.message}'),
  );
}
```

### Creating a chain of error handlers

```dart
Future<Result<UserProfile>> getUserProfile(String userId) async {
  // First try to get the user
  final userResult = await runSafetyFuture(() => api.getUser(userId));
  
  // Early return if user fetch failed
  if (userResult.isFailure) {
    return Results.error(userResult.errorOrNull!);
  }
  
  // Now try to get the profile using the user
  final user = userResult.valueOrNull!;
  return runSafetySync(() => profileService.getProfileForUser(user));
}
```

## Learn more

For complete API documentation, see the [API reference](https://pub.dev/documentation/catch_and_flow/latest/).
