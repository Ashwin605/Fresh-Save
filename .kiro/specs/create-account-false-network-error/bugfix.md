# Bugfix Requirements Document

## Introduction

On the Create Account screen in the FreshSave customer app (Flutter), tapping "Create Account" with a working internet connection incorrectly triggers two error indicators: a red banner at the top reading "You're offline. Some information may be outdated." and a red snackbar reading "Network error occurred." Account creation fails as a result.

The root cause is that any `DioException` type not explicitly mapped in `ApiErrorHandler.handle()` falls through to a `default` case that returns `AppError.network`, which the `RetryInterceptor` then uses to call `markOffline()` on the `networkStatusProvider`. This conflates server-side failures, configuration issues (wrong base URL, TLS errors), and unclassified Dio errors with a genuine loss of device connectivity — causing the offline banner and a misleading snackbar to appear even when the device is fully online.

## Bug Analysis

### Current Behavior (Defect)

1.1 WHEN the user taps "Create Account" with valid form data and the device has an active internet connection, but the `POST /auth/register` request encounters a `DioException` whose type is not explicitly handled by `ApiErrorHandler.handle()`, THEN the system returns `AppError.network` as a catch-all error.

1.2 WHEN `AppError.network` is returned from a failed `/auth/register` call, THEN the `RetryInterceptor` calls `markOffline()` on the `networkStatusProvider`, causing the `GlobalErrorBoundary` to display the red "You're offline. Some information may be outdated." banner even though the device has connectivity.

1.3 WHEN `AppError.network` is returned and surfaced as the error state in `AuthController`, THEN the `register_screen.dart` listener shows a red snackbar with the message "Network error occurred" regardless of the actual cause of the failure.

### Expected Behavior (Correct)

2.1 WHEN the `POST /auth/register` request fails with a `DioException` type that does not indicate a genuine loss of device connectivity (e.g., `connectionError` caused by an unreachable server, wrong base URL, or TLS failure), THEN the system SHALL NOT return `AppError.network` as the error type for that failure, and SHALL instead return an appropriate error type (e.g., `AppError.server` or `AppError.unknown`).

2.2 WHEN the `RetryInterceptor` evaluates a failed `/auth/register` (POST) request, THEN the system SHALL NOT call `markOffline()` unless the failure is confirmed to be caused by the device having no internet connectivity, ensuring the offline banner is not shown for server-side or configuration-related failures.

2.3 WHEN account creation fails due to a non-connectivity error, THEN the system SHALL display an accurate, user-friendly error message (e.g., "Something went wrong. Please try again.") via the snackbar instead of "Network error occurred."

### Unchanged Behavior (Regression Prevention)

3.1 WHEN the device genuinely has no internet connection and the user attempts any API call, THEN the system SHALL CONTINUE TO call `markOffline()`, display the red "You're offline. Some information may be outdated." banner, and surface an appropriate offline error message.

3.2 WHEN the `POST /auth/register` request succeeds (HTTP 2xx), THEN the system SHALL CONTINUE TO automatically log the user in by calling `login()` and transition to the authenticated state.

3.3 WHEN the `POST /auth/register` request fails with an explicitly handled HTTP status code (e.g., 409 Conflict for a duplicate email, 422 for validation failure, 429 for rate limiting), THEN the system SHALL CONTINUE TO return the correctly typed `AppError` variant for that status code.

3.4 WHEN a GET, PUT, or DELETE request fails with a retryable error and the retry count is below the maximum, THEN the system SHALL CONTINUE TO retry the request with exponential backoff as currently implemented.

3.5 WHEN a successful API response is received for any request, THEN the system SHALL CONTINUE TO call `markOnline()`, clearing the offline banner if it was previously shown.

---

## Bug Condition

**Bug Condition Function:**
```pascal
FUNCTION isBugCondition(X)
  INPUT: X of type DioException from POST /auth/register
  OUTPUT: boolean

  // Returns true when the exception type is not an explicit connectivity loss
  // but is still mapped to AppError.network by the default case
  RETURN X.type NOT IN {
    connectionTimeout,
    sendTimeout,
    receiveTimeout,
    badResponse
  }
  AND X.type IN { connectionError, unknown, cancel, badCertificate }
END FUNCTION
```

**Property: Fix Checking**
```pascal
FOR ALL X WHERE isBugCondition(X) DO
  result ← register'(X)  // register() after the fix
  ASSERT result.errorType NOT IN { AppError.network }
  AND networkStatus = online  // offline banner not shown
  AND snackbarMessage != 'Network error occurred'
END FOR
```

**Property: Preservation Checking**
```pascal
FOR ALL X WHERE NOT isBugCondition(X) DO
  ASSERT register(X) = register'(X)
  // Existing error mappings and offline detection unchanged
END FOR
```
