# SECURITY_AUDIT_FIREBASE.md

==================================================
1. EXECUTIVE SUMMARY
==================================================

**Overall Firebase Security Assessment:** C
**Overall Authentication Security Assessment:** C
**Overall Android Security Assessment:** D
**Overall Release-Build Security Assessment:** F

**Critical Security Risks:**
- Release builds are currently signed using the debug keystore (`signingConfigs.getByName("debug")`), rendering APKs insecure and ineligible for Play Store deployment.
- Authentication tokens (Firebase ID Token) are stored in plaintext `SharedPreferences` instead of `FlutterSecureStorage`.
- `google-services.json` containing the Firebase API Key is not excluded in `.gitignore` and is committed to source control.

**High-Risk Issues:**
- Missing confirmation of Backend token verification: Backend authorization must explicitly verify the Firebase ID Token using Firebase Admin SDK instead of blindly trusting the JWT token.
- Lack of ProGuard/R8 configuration for minification and obfuscation in release builds.

**Medium-Risk Issues:**
- Firebase Initialization lacks platform-specific `firebase_options.dart`, which may cause crashes or insecurity on non-Android platforms.
- `applicationId` is left as default `com.example.customer_app`.

**Low-Risk Issues:**
- Unnecessary default comments in Android `build.gradle.kts`.

**Informational Observations:**
- Email verification has just been implemented.
- Google Sign-In is configured and implemented.

**Rating:** F (Release Security failure)
*Reason:* Any production build shipped with the `debug` signing config is fundamentally flawed and vulnerable to hijacking. The application is not production-ready until this is resolved.

==================================================
2. FIREBASE PROJECT CONFIGURATION
==================================================

- **Firebase project configuration:** Provided via `google-services.json`
- **Firebase project ID:** `fresh-save-main` (deduced from storage bucket `fresh-save-main.firebasestorage.app`)
- **Android package/application ID:** `com.example.customer_app`
- **Google Services configuration:** The Android app utilizes `com.google.gms.google-services` plugin.
- **google-services.json usage:** Placed at `apps/customer_app/customer_app/android/app/google-services.json`. 
- **Hardcoded Firebase Configuration:** None found explicitly in Dart code, relies on Android configuration.
- **Multiple Environments:** NOT VERIFIED / REQUIRES MANUAL VERIFICATION (No staging/dev split observed in codebase).

**Configuration Flow:**
Flutter application
→ Android Gradle
→ google-services.json
→ Google Services Gradle plugin (`com.google.gms.google-services`)
→ Firebase SDK
→ Firebase project

==================================================
3. FIREBASE INITIALIZATION AUDIT
==================================================

**Sequence:**
Application startup
→ `WidgetsFlutterBinding.ensureInitialized()`
→ `Firebase.initializeApp()`
→ `SharedPreferences` initialization
→ `ProviderScope`
→ `FreshSaveApp`
→ `MaterialApp.router`

- `Firebase.initializeApp()` is called correctly before `runApp()`.
- It is `await`ed.
- `firebase_options.dart` is NOT used; the application directly relies on `google-services.json` through the Android configuration.

==================================================
4. FIREBASE AUTHENTICATION AUDIT
==================================================

**Methods Implemented:**
- Email/Password (`signInWithEmailAndPassword`, `createUserWithEmailAndPassword`)
- Google Sign-In (`signInWithCredential` via `GoogleAuthProvider`)
- Password Reset (`sendPasswordResetEmail`)
- Sign Out (`signOut`)

**Implementation Details:**
- **Location:** `AuthRepositoryImpl` (lib/features/auth/data/repositories/auth_repository_impl.dart).
- **Credentials:** Email and Password collected via standard text fields in `LoginScreen` and `RegisterScreen`. Transmitted securely over HTTPS via Firebase SDK.
- **Error Handling:** Handled via `ApiErrorHandler.handle(e)` and propagated to `AuthController`.
- **Session Persistence:** Managed inherently by Firebase SDK, but the `AuthRepositoryImpl` ALSO extracts the ID token (`await user.getIdToken()`) and stores it via `TokenStorage`.
- **Email Verification:** Mandated during login (`if (!user.emailVerified) throw Exception(...)`).
- **Token Storage:** Tokens are explicitly saved in `TokenStorage`. (See Local Storage Security section).

==================================================
5. AUTHENTICATION FLOW DIAGRAM
==================================================

User
 ↓
FreshSave Login/Register Screen
 ↓
AuthController (Riverpod Notifier)
 ↓
AuthRepositoryImpl
 ↓
Firebase Authentication SDK (Email or Google Sign-In)
 ↓
Token Extracted (`getIdToken`)
 ↓
TokenStorage (Saved Locally)
 ↓
AuthStateProvider updated with User details
 ↓
Application Router redirects to Authenticated screens

==================================================
6. CREDENTIAL SECURITY
==================================================

- **Firebase ID tokens:** Exchanged with Firebase and manually stored using `TokenStorage`.
- **Storage Mechanism:** The `TokenStorage` relies on `SharedPreferences`, which stores key-value pairs in plaintext XML files on Android. This is highly insecure for sensitive access tokens.
- **Git Repository:** `google-services.json` is tracked in the repository, potentially exposing the Firebase API key and App ID.

==================================================
7. ANDROID SECURITY
==================================================

- **applicationId:** `com.example.customer_app` (Should not use `com.example`).
- **google-services.json:** Present and active.
- **signingConfigs:** Release builds use the debug key.
- **Permissions:** Standard Internet permissions.
- **ProGuard/R8:** No explicit ProGuard rules or minification settings detected in `build.gradle.kts`.

==================================================
8. FIREBASE SECURITY RULES
==================================================

NOT VERIFIED / REQUIRES MANUAL VERIFICATION.
Firebase security rules (`firestore.rules`, `storage.rules`, `database.rules.json`) could not be verified from the repository.

==================================================
9. BACKEND AUTHORIZATION
==================================================

The application recently transitioned from custom REST endpoints (`/auth/login`) to Firebase Authentication. The backend currently exposes NestJS endpoints (e.g., in `PaymentsModule`, `AuthModule`). 

**Critical Requirement:** The backend MUST be updated to verify the incoming Firebase ID token using the Firebase Admin SDK (`firebaseAdmin.auth().verifyIdToken()`). If it blindly parses JWTs without verification against Firebase, it is severely vulnerable.

==================================================
10. API SECURITY
==================================================

- **Authorization:** API relies on the `accessToken` provided by `TokenStorage`. 
- **Request Validation:** Handled by NestJS decorators and DTOs (e.g., `CreatePaymentDto`).

==================================================
11. FIREBASE API KEY SECURITY
==================================================

The Firebase API key contained in `google-services.json` is exposed because the file is not in `.gitignore`. 
While Firebase API keys are technically public (designed to be embedded in apps), they should have **API Key Restrictions** (e.g., restricted to the Android app's SHA-1 fingerprint and package name) in the Google Cloud Console to prevent quota theft and abuse.

==================================================
12. GOOGLE SIGN-IN / OAUTH SECURITY
==================================================

ACTUALLY IMPLEMENTED.
- **Implementation:** Uses `google_sign_in` package to retrieve `accessToken` and `idToken`, which are exchanged for a Firebase `UserCredential`.
- **Android OAuth configuration:** Relies on the SHA-1 certificate fingerprint registered in Firebase. Since release builds use the debug signing config, the debug SHA-1 is currently the only one functioning for Google Sign-In.

==================================================
13. ROUTING AND SESSION SECURITY
==================================================

- **Routing:** Controlled by GoRouter, guided by the Riverpod `authStateProvider`. Navigation is blocked for unauthenticated users at the UI level.
- **Deep Links:** NOT VERIFIED / REQUIRES MANUAL VERIFICATION.

==================================================
14. LOCAL STORAGE SECURITY
==================================================

Data → TokenStorage → `SharedPreferences`
**Encryption Status:** UNENCRYPTED PLAINTEXT.
**Lifetime:** Until explicitly logged out or app data cleared.
**Security Risk:** HIGH. Any local exploit or root access can easily steal the user's Firebase ID token and masquerade as the user. Must be migrated to `flutter_secure_storage`.

==================================================
15. RELEASE BUILD SECURITY
==================================================

**Evidence from `build.gradle.kts`:**
```kotlin
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("debug")
    }
}
```
**Risk:** CRITICAL. The release APK is signed with a publicly known, insecure debug key. It cannot be uploaded to the Google Play Store and is vulnerable to malicious tampering if side-loaded.

==================================================
16. SOURCE CONTROL SECURITY
==================================================

`.gitignore` inspection reveals:
- `.env` files are ignored.
- `google-services.json` is NOT ignored. It is present in the repository history.

==================================================
17. DEPENDENCY SECURITY
==================================================

**Current Versions:**
- `firebase_auth: ^6.7.0`
- `firebase_core: ^4.15.0`
- `google_sign_in: ^7.2.0`
- `shared_preferences: ^2.5.5`

**Known Issues:** None specifically vulnerable, but `flutter_secure_storage: ^11.0.0` is present in `pubspec.yaml` but NOT used by `TokenStorage`.

==================================================
18. THREAT MODEL
==================================================

1. **Malicious App Resigner (Compromised Device):**
   - *Attack:* Reverse engineer the APK, alter code, and re-sign it with the debug key.
   - *Existing Protection:* None. Release builds use the debug key.
   - *Mitigation:* Implement a proper release keystore.

2. **Local Token Theft:**
   - *Attack:* Attacker with physical access or malware extracts `SharedPreferences` XML to steal Firebase ID token.
   - *Existing Protection:* None.
   - *Mitigation:* Use `flutter_secure_storage` to encrypt tokens.

3. **Backend Authorization Bypass:**
   - *Attack:* Forged JWT tokens sent to backend.
   - *Existing Protection:* Relies on backend verification.
   - *Mitigation:* Enforce `firebase-admin` token verification on the NestJS backend.

==================================================
19. FINDINGS TABLE
==================================================

| ID | Severity | Component | Finding | Evidence | Impact | Recommendation |
|----|----------|-----------|---------|----------|--------|----------------|
| 01 | CRITICAL | Android Gradle | Release build signed with debug key | `build.gradle.kts` line 33 | App can be tampered with and side-loaded | Generate a release keystore and update `buildTypes.release` |
| 02 | HIGH | Local Storage | Access tokens stored in plaintext | `TokenStorage` using `SharedPreferences` | Session hijacking | Use `flutter_secure_storage` for token persistence |
| 03 | MEDIUM | Android Config | Default application ID used | `applicationId = "com.example.customer_app"` | App store conflicts | Change `applicationId` to a unique domain |
| 04 | LOW | Source Control | `google-services.json` committed | Missing in `.gitignore` | API Key exposure | Add to `.gitignore`, use API Key Restrictions |

==================================================
20. FIREBASE SECURITY SCORECARD
==================================================

- Firebase Configuration: PARTIAL (Missing `firebase_options.dart` for cross-platform, exposed in git)
- Authentication: PASS
- Authorization: NOT VERIFIED
- Token Handling: FAIL (Stored in SharedPreferences)
- Backend Verification: NOT VERIFIED (Backend code review required for Firebase ID token verification)
- Firestore Rules: NOT VERIFIED
- Storage Rules: NOT VERIFIED
- Android Security: FAIL (Debug Keystore used for Release)
- Local Storage: FAIL
- Release Security: FAIL

==================================================
21. PRIORITIZED REMEDIATION PLAN
==================================================

**P0 — Immediate**
- *Problem:* Release builds use debug keystore.
- *File:* `android/app/build.gradle.kts`
- *Approach:* Generate a `upload-keystore.jks`, configure a `key.properties` file, and update Gradle to use the release signing config.

**P1 — High Priority**
- *Problem:* Tokens stored in plaintext.
- *File:* `TokenStorage` (likely `lib/core/storage/token_storage.dart`)
- *Approach:* Migrate from `SharedPreferences` to `FlutterSecureStorage`.

**P2 — Medium Priority**
- *Problem:* `google-services.json` in source control.
- *File:* `.gitignore`
- *Approach:* Add `google-services.json` to `.gitignore`. Secure API key in Google Cloud Console.

**P3 — Hardening**
- *Problem:* Lack of `firebase_options.dart`.
- *File:* `main.dart`
- *Approach:* Run `flutterfire configure` to generate proper multi-platform Firebase initialization.

==================================================
22. FINAL VERDICT
==================================================

- **Overall security rating:** F
- **Top 5 security risks:** Debug keystore on release, plaintext token storage, `google-services.json` exposure, unverified backend JWT verification, default package name.
- **Firebase readiness:** PARTIAL
- **Production readiness:** FAIL
- **Authentication readiness:** PARTIAL (Client-side logic is sound, but storage is insecure)
- **Release APK security readiness:** FAIL

*Note: Firebase Security Rules and Backend Verification require manual verification in the respective consoles and backend service controllers.*
