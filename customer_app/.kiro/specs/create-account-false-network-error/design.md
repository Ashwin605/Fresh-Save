# Create Account False Network Error — Bugfix Design

## Overview

When a user taps "Create Account" in the FreshSave customer app, the request fails (e.g., due to a TLS error, wrong base URL, or unreachable server). Because `DioExceptionType.connectionError` is included in `_isNetworkIssue()`, the interceptor calls `markOffline()`, which triggers the global offline banner ("You're offline. Some information may be outdated."). Simultaneously, `ApiErrorHandler.handle()` falls through to its `default` case and returns `AppError.network`, whose message field reads "Network error occurred" — displayed as a snackbar.

The fix is surgical: `connectionError` must be removed from the "is this an offline state?" check, and `ApiErrorHandler` must handle `DioExceptionType.connectionError` explicitly with a more accurate server-reachability error instead of masking it as a connectivity loss.

## Glossary

- **Bug_Condition (C)**: A `DioException` whose `type` is `connectionError` — a non-timeout transport failure that is not caused by the device being offline.
- **Property (P)**: The desired behavior when the bug condition holds — the app shows an accurate server-reachability error without triggering the offline banner or the "Network error occurred" snackbar.
- **Preservation**: All behaviors that must be unchanged: genuine offline detection (timeouts), retry logic, HTTP error handling (4xx/5xx), the offline banner for real offline states, and all other snackbar messages.
- **RetryInterceptor**: The Dio interceptor in `customer_app/lib/core/network/dio_client.dart` that calls `markOffline()` / `markOnline()` and drives retry logic.
- **ApiErrorHandler**: The static class in `customer_app/lib/core/network/dio_client.dart` that maps `DioException` values to `AppError` variants shown in the UI.
- **NetworkStatusNotifier**: The Riverpod notifier in `customer_app/lib/core/network/network_status_provider.dart` that exposes the `online`/`offline` state consumed by `GlobalErrorBoundary`.
- **GlobalErrorBoundary**: The widget in `customer_app/lib/core/error/global_error_boundary.dart` that shows the red offline banner whenever `networkStatusProvider` is `offline`.
- **connectionError**: `DioExceptionType.connectionError` — fired by Dio for TCP/TLS failures, DNS resolution failures, or an unreachable server. It does **not** imply the device has no network interface.

## Bug Details

### Bug Condition

The bug manifests when a `DioException` with `type == DioExceptionType.connectionError` is thrown during any API call (the Create Account request in the reported case). `RetryInterceptor._isNetworkIssue()` returns `true` for this type, so `markOffline()` is called even though the device has working internet. Simultaneously, `ApiErrorHandler.handle()` has no explicit case for `connectionError` and falls to `default`, returning `AppError.network` — the least specific error variant — causing the misleading "Network error occurred" snackbar.

**Formal Specification:**
```
FUNCTION isBugCondition(err)
  INPUT: err of type DioException
  OUTPUT: boolean

  RETURN err.type == DioExceptionType.connectionError
END FUNCTION
```

### Examples

- **TLS handshake failure** — Server certificate is invalid or self-signed. Dio throws `connectionError`. Expected: snackbar says "Unable to reach server. Please try again." and NO offline banner. Actual: offline banner appears, snackbar says "Network error occurred".
- **Wrong base URL (development)** — `API_URL` env var is not set; default `http://10.0.2.2:3000/api/v1` is unreachable on a physical device. Expected: server-reachability error message. Actual: offline banner + "Network error occurred".
- **Server down (503 not yet received)** — TCP connection refused before HTTP response. Expected: server-reachability error. Actual: offline banner + "Network error occurred".
- **Genuine device offline** — No network interface available. `connectionTimeout` or `connectionError` fires after timeout. Expected: offline banner is shown (correct). Actual: already correct for timeouts; `connectionError` also triggers it, but here the result is coincidentally accurate for this one case.

## Expected Behavior

### Preservation Requirements

**Unchanged Behaviors:**
- `DioExceptionType.connectionTimeout`, `sendTimeout`, and `receiveTimeout` MUST continue to call `markOffline()` and show the offline banner — these reliably indicate the device cannot reach the network.
- HTTP error codes (401, 403, 404, 409, 422, 429, 500–504) MUST continue to map to their existing `AppError` variants unchanged.
- `AppError.timeout` with message "Connection timed out" MUST remain the response to timeout exceptions.
- Successful responses MUST continue to call `markOnline()`.
- Retry logic for idempotent requests on retryable errors MUST be unaffected.
- The offline banner MUST still appear when the device is genuinely offline (timeouts remain in `_isNetworkIssue()`).
- All existing snackbar messages for non-`connectionError` failures MUST remain identical.

**Scope:**
Only inputs where `err.type == DioExceptionType.connectionError` are affected by this fix. All other `DioExceptionType` values and all HTTP response errors follow unchanged code paths.

## Hypothesized Root Cause

1. **Over-broad `_isNetworkIssue()` classification**: `DioExceptionType.connectionError` was grouped with timeout types under the assumption that any connection failure implies the device is offline. In practice, `connectionError` is also raised for TLS failures, DNS errors, and refused TCP connections — all of which can occur when the device has a working internet connection but the server or URL is the problem.

2. **Missing explicit case in `ApiErrorHandler.handle()`**: The `switch` statement handles `connectionTimeout`, `sendTimeout`, `receiveTimeout`, and `badResponse` by name, but has no `case` for `connectionError`. It falls to `default`, which returns `AppError.network` — the most generic error variant — regardless of the actual failure. This produces both the wrong message ("Network error occurred" instead of something like "Unable to reach server") and, combined with root cause 1, the wrong UI state (offline banner).

3. **`AppError.network` semantics conflated with offline state**: `AppError.network` is used by the `default` handler to mean "something went wrong with the network" but the UI treats it as equivalent to "device is offline", causing the global offline banner to fire even when it should not.

## Correctness Properties

Property 1: Bug Condition — connectionError Does Not Trigger Offline State

_For any_ `DioException` where `isBugCondition` returns true (i.e., `type == connectionError`), the fixed `RetryInterceptor` SHALL call `markOnline()` (not `markOffline()`), and `ApiErrorHandler.handle()` SHALL return `AppError.server` (or a dedicated `AppError.connectionError` variant) with a message such as "Unable to reach server. Please try again." — ensuring no offline banner appears and the snackbar message is accurate.

**Validates: Requirements 2.1, 2.2**

Property 2: Preservation — Timeout Errors Still Trigger Offline State

_For any_ `DioException` where `isBugCondition` returns false and the type is one of `connectionTimeout`, `sendTimeout`, or `receiveTimeout`, the fixed `RetryInterceptor` SHALL call `markOffline()` and `ApiErrorHandler.handle()` SHALL return `AppError.timeout` — identical behavior to the original code.

**Validates: Requirements 3.1, 3.2, 3.3**

## Fix Implementation

### Changes Required

**File**: `customer_app/lib/core/network/dio_client.dart`

#### 1. Remove `connectionError` from `_isNetworkIssue()`

`connectionError` must no longer be treated as an offline signal. The revised method covers only timeout-based types, which reliably indicate the device cannot reach any network endpoint.

```dart
bool _isNetworkIssue(DioException err) {
  return err.type == DioExceptionType.connectionTimeout ||
      err.type == DioExceptionType.sendTimeout ||
      err.type == DioExceptionType.receiveTimeout;
  // connectionError is intentionally excluded: it covers TLS failures,
  // DNS errors, and refused connections — not genuine offline states.
}
```

#### 2. Keep `connectionError` retryable in `_isRetryableError()`

`connectionError` can still be worth retrying (e.g., transient DNS hiccup). It must remain in `_isRetryableError()` so retry logic is preserved for idempotent requests. No change needed here — `_isRetryableError()` already calls `_isNetworkIssue()` and adds HTTP 5xx/429; `connectionError` will fall through to the HTTP status check. However, since `connectionError` has no HTTP response, the status check returns `false`. To preserve retryability:

```dart
bool _isRetryableError(DioException err) {
  if (err.type == DioExceptionType.connectionTimeout ||
      err.type == DioExceptionType.sendTimeout ||
      err.type == DioExceptionType.receiveTimeout ||
      err.type == DioExceptionType.connectionError) { // keep connectionError retryable
    return true;
  }
  final statusCode = err.response?.statusCode;
  return statusCode == 500 ||
      statusCode == 502 ||
      statusCode == 503 ||
      statusCode == 504 ||
      statusCode == 429;
}
```

#### 3. Handle `connectionError` explicitly in `ApiErrorHandler.handle()`

Add a named `case` before `default` so `connectionError` maps to a specific, accurate error variant instead of the generic `AppError.network`:

```dart
case DioExceptionType.connectionError:
  return const AppError.server(
    message: 'Unable to reach server. Please try again.',
  );
```

This reuses the existing `AppError.server` variant (no new type needed) with a user-facing message that distinguishes server-reachability failures from generic network loss.

#### 4. (Optional — no code change required) Verify `onError` offline/online branching

After step 1, `_isNetworkIssue(connectionError)` returns `false`, so the `onError` branch already calls `markOnline()` for `connectionError`. No further change is needed in `onError`.

## Testing Strategy

### Validation Approach

Testing follows two phases: first run exploratory tests against the **unfixed** code to confirm the bug manifests as described and to validate the root cause hypothesis; then run fix-checking and preservation tests against the **fixed** code.

### Exploratory Bug Condition Checking

**Goal**: Surface counterexamples demonstrating the bug on unfixed code. Confirm that `connectionError` triggers `markOffline()` and returns `AppError.network`.

**Test Plan**: Create a `DioException` with `type == connectionError`, pass it through `RetryInterceptor.onError` (using a mock `Ref`) and `ApiErrorHandler.handle()`, and assert the incorrect behaviors that constitute the bug.

**Test Cases**:
1. **Offline banner triggered on connectionError** — Fire a `connectionError` through `RetryInterceptor.onError`; assert `markOffline()` is called. (Will fail on fixed code — used to confirm bug on unfixed code.)
2. **Wrong snackbar message** — Pass a `connectionError` to `ApiErrorHandler.handle()`; assert it returns `AppError.network` with message "Network error occurred". (Will fail on fixed code — confirms the missing explicit case.)
3. **markOnline NOT called for connectionError** — Verify that `markOnline()` is NOT called when `connectionError` fires on unfixed code (confirming the branch taken).
4. **Timeout still calls markOffline** — Fire a `connectionTimeout` through `onError`; assert `markOffline()` IS called (confirms timeout handling is unaffected on both unfixed and fixed code).

**Expected Counterexamples**:
- `markOffline()` is called for `connectionError` on unfixed code.
- `ApiErrorHandler.handle()` returns `AppError.network` for `connectionError` on unfixed code.

### Fix Checking

**Goal**: Verify that for all inputs where the bug condition holds, the fixed code produces the correct behavior.

**Pseudocode:**
```
FOR ALL err WHERE isBugCondition(err) DO
  -- RetryInterceptor behavior
  ASSERT markOnline() IS called
  ASSERT markOffline() IS NOT called

  -- ApiErrorHandler behavior  
  result := ApiErrorHandler.handle(err)
  ASSERT result IS AppError.server
  ASSERT result.message == 'Unable to reach server. Please try again.'
END FOR
```

### Preservation Checking

**Goal**: Verify that for all inputs where the bug condition does NOT hold, the fixed code behaves identically to the original.

**Pseudocode:**
```
FOR ALL err WHERE NOT isBugCondition(err) DO
  ASSERT RetryInterceptor_original(err) == RetryInterceptor_fixed(err)
  ASSERT ApiErrorHandler_original(err) == ApiErrorHandler_fixed(err)
END FOR
```

**Testing Approach**: Property-based testing is appropriate here because the non-buggy input space (all `DioExceptionType` values except `connectionError`, plus all HTTP status codes) is large and enumerable. A PBT generator can cover the full space and catch any accidental regressions.

**Test Cases**:
1. **Timeout types still mark offline** — For each of `connectionTimeout`, `sendTimeout`, `receiveTimeout`: assert `markOffline()` is called and `ApiErrorHandler` returns `AppError.timeout`.
2. **badResponse still maps to correct AppError** — For each HTTP status code (401, 403, 404, 409, 422, 429, 500, 503): assert unchanged `AppError` variant is returned.
3. **Successful response still marks online** — Assert `markOnline()` is called in `onResponse`.
4. **Retry logic unaffected** — Assert `connectionError` on a GET request still triggers a retry (i.e., `_isRetryableError` returns `true` for `connectionError`).
5. **Non-connectionError types unchanged** — Property test: generate random `DioExceptionType` values excluding `connectionError`; assert `ApiErrorHandler.handle()` output matches pre-fix behavior.

### Unit Tests

- Test `_isNetworkIssue()` returns `false` for `connectionError` after fix.
- Test `_isNetworkIssue()` returns `true` for each of `connectionTimeout`, `sendTimeout`, `receiveTimeout`.
- Test `_isRetryableError()` returns `true` for `connectionError` (retryability preserved).
- Test `ApiErrorHandler.handle()` returns `AppError.server` with correct message for `connectionError`.
- Test `ApiErrorHandler.handle()` returns `AppError.timeout` for all three timeout types (unchanged).
- Test `ApiErrorHandler.handle()` returns correct `AppError` for each HTTP status code (unchanged).
- Test `RetryInterceptor.onError` calls `markOnline()` (not `markOffline()`) for `connectionError`.
- Test `RetryInterceptor.onError` calls `markOffline()` for `connectionTimeout`.

### Property-Based Tests

- Generate random `DioExceptionType` values (excluding `connectionError`) and assert `_isNetworkIssue()` output matches the original implementation for all of them.
- Generate random HTTP status codes and assert `ApiErrorHandler.handle(badResponse)` output is unchanged.
- Generate random `DioExceptionType` values and assert `_isRetryableError()` output is unchanged (since retryability of `connectionError` is preserved explicitly).

### Integration Tests

- Full Create Account flow with a mocked server that closes the TCP connection (simulates `connectionError`): assert no offline banner, assert snackbar message is "Unable to reach server. Please try again.".
- Full Create Account flow with device in airplane mode (simulates `connectionTimeout`): assert offline banner DOES appear.
- Full Create Account flow with valid server returning 422: assert validation error snackbar, no offline banner.
