import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/auth_models.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/storage/token_storage.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    dio: ref.watch(dioProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
    firebaseAuth: firebase.FirebaseAuth.instance,
    googleSignIn: GoogleSignIn(),
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

  User _mapFirebaseUser(firebase.User user) {
    return User(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? 'User',
      role: 'customer', // Default role
      phone: user.phoneNumber,
    );
  }

  @override
  Future<Result<LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) throw Exception('Login failed');

      if (!user.emailVerified) {
        await firebaseAuth.signOut();
        throw Exception('Please verify your email address before logging in.');
      }

      final token = await user.getIdToken() ?? '';
      final ourUser = _mapFirebaseUser(user);
      
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
      // Note: We don't need to manually clear tokens since Firebase is the source of truth.


      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) throw Exception('Registration failed');

      await user.updateDisplayName(name);
      await user.sendEmailVerification();

      // CRITICAL: Sign out IMMEDIATELY.
      // This ensures no race condition can allow the unverified user through.
      await firebaseAuth.signOut();


      final ourUser = User(
        id: user.uid,
        email: user.email ?? email,
        name: name,
        role: 'customer',
        phone: phone,
      );
      
      return Result.success(ourUser);
    } catch (e) {
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
      // Note: We don't need to manually clear tokens since Firebase is the source of truth.

      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) throw Exception('Registration failed');

      await user.updateDisplayName(ownerName);
      await user.sendEmailVerification();

      // CRITICAL: Sign out immediately
      await firebaseAuth.signOut();


      final ourUser = User(
        id: user.uid,
        email: user.email ?? email,
        name: ownerName,
        role: 'owner',
        phone: phone,
      );
      
      return Result.success(ourUser);
    } catch (e) {
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
      
      return Result.success(_mapFirebaseUser(user));
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await firebaseAuth.signOut();
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
