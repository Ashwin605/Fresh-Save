# Implementation Plan

- [ ] 1. Write bug condition exploration test
  - **Property 1: Bug Condition** - False Offline Detection on connectionError
  - **CRITICAL**: This test MUST FAIL on unfixed code - failure confirms the bug exists
  - **DO NOT attempt to fix the test or the code when it fails**
  - **NOTE**: This test encodes the expected behavior - it will validate the fix when it passes after implementation
  - **GOAL**: Surface counterexamples that demonstrate that `DioExceptionType.connectionError` (and other unhandled types such as `unknown`, `cancel`, `badCertificate`) are incorrectly mapped to `AppError.network` and trigger `markOffline()`
  - **Scoped PBT Approach**: Scope the property to the concrete failing case — a `DioException` with `type == DioExceptionType.connectionError` passed to `ApiErrorHandler.handle()` — to ensure reproducibility
  - File: `customer_app/test/core/network/dio_client_test.dart`
  - Test `ApiErrorHandler.handle()` with a `DioException` whose `type` satisfies `isBugCondition` (i.e., `connectionError`, `unknown`, `cancel`, `badCertificate`) — assert the returned `AppError` is NOT `AppError.network`
  - Also test that `RetryInterceptor._isNetworkIssue()` returns `false` for `connectionError` (assert `markOffline()` is NOT called for these types)
  - The test assertions match the **Property: Fix Checking** from bugfix.md: `result.errorType NOT IN { AppError.network }` and `networkStatus = online`
  - Run test on UNFIXED code (`customer_app/lib/core/network/dio_client.dart` as-is)
  - **EXPECTED OUTCOME**: Test FAILS (this is correct — it proves the bug exists, e.g. `ApiErrorHandler.handle(connectionError)` currently returns `AppError.network`)
  - Document counterexamples found to understand root cause (e.g. "`handle(DioException(type: connectionError))` returns `AppError.network` instead of `AppError.server`")
  - Mark task complete when test is written, run, and failure is documented
  - _Requirements: 1.1, 1.2, 1.3_

- [ ] 2. Write preservation property tests (BEFORE implementing fix)
  - **Property 2: Preservation** - Existing Error Mappings and Offline Detection Unchanged
  - **IMPORTANT**: Follow observation-first methodology
  - File: `customer_app/test/core/network/dio_client_test.dart`
  - Observe on UNFIXED code:
    - `handle(DioException(type: connectionTimeout))` → `AppError.timeout`
    - `handle(DioException(type: sendTimeout))` → `AppError.timeout`
    - `handle(DioException(type: receiveTimeout))` → `AppError.timeout`
    - `handle(DioException(type: badResponse, statusCode: 401))` → `AppError.unauthorized`
    - `handle(DioException(type: badResponse, statusCode: 409))` → `AppError.conflict`
    - `handle(DioException(type: badResponse, statusCode: 422))` → `AppError.validation`
    - `handle(DioException(type: badResponse, statusCode: 429))` → `AppError.rateLimited`
    - `_isNetworkIssue(DioException(type: connectionTimeout))` → `true` (markOffline still triggered)
    - `_isRetryableError(DioException(type: badResponse, statusCode: 500))` → `true` (retries still work)
  - Write property-based tests (using `dart_test` or a Dart PBT library) capturing these observed behavior patterns from the **Preservation Requirements** (3.1–3.5) in bugfix.md:
    - For all `X` where `X.type IN {connectionTimeout, sendTimeout, receiveTimeout}`: `handle(X)` returns `AppError.timeout` (covers 3.1 genuine offline detection)
    - For all `X` where `X.type == badResponse` and known status codes: `handle(X)` returns the correct typed variant (covers 3.3)
    - `_isNetworkIssue` still returns `true` for timeout types so `markOffline()` fires for genuine connectivity loss (covers 3.1)
    - Successful responses still call `markOnline()` (covers 3.5)
    - GET/PUT/DELETE retryable errors still trigger retry logic (covers 3.4)
  - Run tests on UNFIXED code
  - **EXPECTED OUTCOME**: Tests PASS (this confirms baseline behavior to preserve)
  - Mark task complete when tests are written, run, and passing on unfixed code
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_

- [ ] 3. Fix false offline detection caused by unhandled DioException types

  - [ ] 3.1 Remove `connectionError` from `_isNetworkIssue()` in `RetryInterceptor`
    - File: `customer_app/lib/core/network/dio_client.dart`
    - In `RetryInterceptor._isNetworkIssue()`, remove the `err.type == DioExceptionType.connectionError` clause from the return expression
    - After the change, only timeout types (`connectionTimeout`, `sendTimeout`, `receiveTimeout`) cause `markOffline()` to be called
    - _Bug_Condition: `isBugCondition(X)` where `X.type == DioExceptionType.connectionError` (and `unknown`, `cancel`, `badCertificate`) — these types previously matched `_isNetworkIssue`, triggering `markOffline()` for non-connectivity failures_
    - _Expected_Behavior: `networkStatus = online` when failure is not a genuine connectivity loss_
    - _Preservation: Timeout types continue to call `markOffline()` (Requirement 3.1); successful responses continue to call `markOnline()` (Requirement 3.5)_
    - _Requirements: 2.2, 3.1, 3.5_

  - [ ] 3.2 Add explicit `connectionError` check to `_isRetryableError()` in `RetryInterceptor`
    - File: `customer_app/lib/core/network/dio_client.dart`
    - In `RetryInterceptor._isRetryableError()`, add an explicit check: `if (err.type == DioExceptionType.connectionError) return true;`
    - This preserves retryability for `connectionError` even though it is no longer a network issue, since an unreachable server may recover on retry
    - _Bug_Condition: Without this, removing `connectionError` from `_isNetworkIssue` would silently stop retrying `connectionError` failures_
    - _Preservation: GET/PUT/DELETE retries with exponential backoff continue working for `connectionError` (Requirement 3.4)_
    - _Requirements: 3.4_

  - [ ] 3.3 Add explicit `connectionError` case to `ApiErrorHandler.handle()`
    - File: `customer_app/lib/core/network/dio_client.dart`
    - In `ApiErrorHandler.handle()`, add an explicit `case DioExceptionType.connectionError:` before the `default:` clause, returning `AppError.server(message: 'Unable to reach server. Please try again.')`
    - This prevents `connectionError` from falling through to `default` and being returned as `AppError.network`
    - _Bug_Condition: `isBugCondition(X)` where `X.type IN {connectionError, unknown, cancel, badCertificate}` previously hit `default:` → `AppError.network`_
    - _Expected_Behavior: `result.errorType NOT IN { AppError.network }` and `snackbarMessage != 'Network error occurred'`_
    - _Preservation: All explicitly handled status codes (401, 403, 404, 409, 422, 429, 503) continue returning correct `AppError` variants (Requirement 3.3)_
    - _Requirements: 2.1, 2.3, 3.3_

  - [ ] 3.4 Verify bug condition exploration test now passes
    - **Property 1: Expected Behavior** - False Offline Detection on connectionError
    - **IMPORTANT**: Re-run the SAME test from task 1 — do NOT write a new test
    - The test from task 1 encodes the expected behavior from the **Property: Fix Checking** in bugfix.md
    - When this test passes, it confirms: `handle(connectionError)` → NOT `AppError.network`, `_isNetworkIssue(connectionError)` → `false`, `markOffline()` NOT called
    - Run bug condition exploration test from step 1
    - **EXPECTED OUTCOME**: Test PASSES (confirms bug is fixed)
    - _Requirements: 2.1, 2.2, 2.3_

  - [ ] 3.5 Verify preservation tests still pass
    - **Property 2: Preservation** - Existing Error Mappings and Offline Detection Unchanged
    - **IMPORTANT**: Re-run the SAME tests from task 2 — do NOT write new tests
    - Run preservation property tests from step 2
    - **EXPECTED OUTCOME**: Tests PASS (confirms no regressions in timeout handling, explicit HTTP code mappings, retry logic, and online/offline state transitions)
    - Confirm all tests still pass after fix (no regressions)
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_

- [ ] 4. Checkpoint — Ensure all tests pass
  - Run the full test suite for `customer_app/test/core/network/dio_client_test.dart`
  - Confirm Property 1 (bug condition) and Property 2 (preservation) both pass
  - Confirm no other tests in the `customer_app` test suite were broken by the changes
  - Ask the user if any questions arise before closing the fix
