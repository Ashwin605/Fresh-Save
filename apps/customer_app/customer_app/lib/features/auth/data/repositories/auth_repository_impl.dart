import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/app_error.dart';
import '../../domain/models/auth_models.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/storage/token_storage.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    dio: ref.watch(dioProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
    firebaseAuth: firebase.FirebaseAuth.instance,
    googleSignIn: GoogleSignIn(
      serverClientId: '356215287106-76m4ug9alq8ek05e8fp7sk6d29lsngvi.apps.googleusercontent.com',
    ),
  );
});

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;
  final TokenStorage tokenStorage;
  final firebase.FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthRepositoryImpl({
    required this.dio,
    required this.tokenStorage,
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  User _mapFirebaseUser(firebase.User user, {String role = 'CUSTOMER'}) {
    return User(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? 'User',
      role: role,
      phone: user.phoneNumber,
    );
  }

  @override
  Future<Result<LoginResponse>> login({
    required String email,
    required String password,
    String? role,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) throw Exception('Login failed');

      if (!user.emailVerified) {
        try {
          await user.sendEmailVerification();
        } catch (_) {}
        await firebaseAuth.signOut();
        throw Exception('Please verify your email address. A new verification link has been sent to your email.');
      }

      final resolvedRole = role ?? await tokenStorage.getUserRole() ?? 'CUSTOMER';
      await tokenStorage.saveUserRole(resolvedRole);

      final token = await user.getIdToken() ?? '';
      final ourUser = _mapFirebaseUser(user, role: resolvedRole);
      
      final loginResponse = LoginResponse(
        user: ourUser,
        tokens: AuthTokens(accessToken: token, refreshToken: ''),
      );

      // Optionally notify backend here if needed, but for now we just use Firebase auth.
      return Result.success(loginResponse);
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<User>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) throw Exception('Registration failed');

      try {
        await user.updateDisplayName(name);
      } catch (_) {}

      try {
        await user.sendEmailVerification();
      } catch (_) {}

      await tokenStorage.saveUserRole('CUSTOMER');

      // CRITICAL: Sign out immediately so state remains unauthenticated until verified
      await firebaseAuth.signOut();

      final ourUser = User(
        id: user.uid,
        email: user.email ?? email,
        name: name,
        role: 'CUSTOMER',
        phone: phone,
      );
      
      return Result.success(ourUser);
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        try {
          final cred = await firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          final existingUser = cred.user;
          if (existingUser != null) {
            if (!existingUser.emailVerified) {
              try {
                await existingUser.updateDisplayName(name);
              } catch (_) {}
              await existingUser.sendEmailVerification();
              await tokenStorage.saveUserRole('CUSTOMER');
              await firebaseAuth.signOut();
              return Result.success(User(
                id: existingUser.uid,
                email: existingUser.email ?? email,
                name: name,
                role: 'CUSTOMER',
                phone: phone,
              ));
            } else {
              await firebaseAuth.signOut();
              return Result.failure(
                const AppError.conflict(
                  message: 'This email is already registered and verified. Please sign in.',
                ),
              );
            }
          }
        } catch (_) {}
      }
      try {
        await firebaseAuth.signOut();
      } catch (_) {}
      return Result.failure(ApiErrorHandler.handle(e));
    } catch (e) {
      try {
        await firebaseAuth.signOut();
      } catch (_) {}
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<User>> registerBusiness({
    required String ownerName,
    required String email,
    required String password,
    String? phone,
    required String businessName,
    required String storeName,
    required String storeAddress,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) throw Exception('Registration failed');

      try {
        await user.updateDisplayName(ownerName);
      } catch (_) {}

      try {
        await user.sendEmailVerification();
      } catch (_) {}

      await tokenStorage.saveUserRole('SHOP_OWNER');

      // CRITICAL: Sign out immediately
      await firebaseAuth.signOut();

      final ourUser = User(
        id: user.uid,
        email: user.email ?? email,
        name: ownerName,
        role: 'SHOP_OWNER',
        phone: phone,
      );
      
      return Result.success(ourUser);
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        try {
          final cred = await firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          final existingUser = cred.user;
          if (existingUser != null) {
            if (!existingUser.emailVerified) {
              try {
                await existingUser.updateDisplayName(ownerName);
              } catch (_) {}
              await existingUser.sendEmailVerification();
              await tokenStorage.saveUserRole('SHOP_OWNER');
              await firebaseAuth.signOut();
              return Result.success(User(
                id: existingUser.uid,
                email: existingUser.email ?? email,
                name: ownerName,
                role: 'SHOP_OWNER',
                phone: phone,
              ));
            } else {
              await firebaseAuth.signOut();
              return Result.failure(
                const AppError.conflict(
                  message: 'This email is already registered and verified. Please sign in to the Shopkeeper portal.',
                ),
              );
            }
          }
        } catch (_) {}
      }
      try {
        await firebaseAuth.signOut();
      } catch (_) {}
      return Result.failure(ApiErrorHandler.handle(e));
    } catch (e) {
      try {
        await firebaseAuth.signOut();
      } catch (_) {}
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<User>> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) throw Exception('Not authenticated');

      // Enforce email verification for returning sessions
      if (!user.emailVerified) {
        final isGoogleUser = user.providerData.any((info) => info.providerId == 'google.com');
        if (!isGoogleUser) {
          await firebaseAuth.signOut();
          throw Exception('Please verify your email address.');
        }
      }
      
      final role = await tokenStorage.getUserRole() ?? 'CUSTOMER';
      return Result.success(_mapFirebaseUser(user, role: role));
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await firebaseAuth.signOut();
      await googleSignIn.signOut();
    } catch (e) {
      // Ignore
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) throw Exception('Not authenticated');
      
      final cred = firebase.EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      
      return const Result.success(null);
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<void>> forgotPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<void>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    // Firebase handles password resets via email links.
    // If the UI relies on OTP, we might need a custom backend or Firebase Extensions.
    // For now, we simulate success or throw an error indicating email link should be used.
    throw Exception('Please use the link sent to your email to reset your password.');
  }

  @override
  Future<Result<LoginResponse>> signInWithGoogle() async {
    try {
      try {
        await googleSignIn.signOut();
      } catch (_) {}

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google Sign-In aborted by user.');
      }

      final googleAuth = await googleUser.authentication;
      final credential = firebase.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) throw Exception('Google Sign-In failed');

      final token = await user.getIdToken() ?? '';
      final ourUser = _mapFirebaseUser(user);

      final loginResponse = LoginResponse(
        user: ourUser,
        tokens: AuthTokens(accessToken: token, refreshToken: ''),
      );

      return Result.success(loginResponse);
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }
}
