import 'package:cricheros_data/service/auth/auth_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'sign_in_view_model.freezed.dart';

final signInStateProvider =
    StateNotifierProvider.autoDispose<SignInViewNotifier, SignInState>((ref) {
  return SignInViewNotifier(ref.read(authServiceProvider));
});

class SignInViewNotifier extends StateNotifier<SignInState> {
  final AuthService _authService;

  // The Web Client ID from Supabase Dashboard > Authentication > Providers >
  // Google - also used as serverClientId here so signInWithIdToken() gets an
  // ID token whose audience Supabase actually accepts. See docs/launch-checklist.md.
  static const _googleWebClientId =
      '842029024914-o53h43nb1rtmae9jl4f28s299ooh6tv9.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: _googleWebClientId,
    scopes: const ['email'],
  );

  SignInViewNotifier(this._authService)
      : super(
          SignInState(
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
          ),
        );

  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void onFieldChange() {
    state = state.copyWith(
      enableBtn: state.emailController.text.trim().isNotEmpty &&
          state.passwordController.text.trim().isNotEmpty,
    );
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(googleSigningIn: true, actionError: null);
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        // User cancelled the account picker - not an error.
        state = state.copyWith(googleSigningIn: false);
        return;
      }
      final googleAuth = await account.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        throw Exception('Google sign-in did not return an ID token');
      }
      await _authService.signInWithGoogle(
        idToken: idToken,
        accessToken: googleAuth.accessToken,
      );
      state = state.copyWith(googleSigningIn: false, signInSuccess: true);
    } catch (error, stack) {
      FirebaseCrashlytics.instance
          .recordError(error, stack, reason: "Google Sign-In Error");
      state = state.copyWith(googleSigningIn: false, actionError: error);
      debugPrint("SignInViewNotifier: error in signInWithGoogle -> $error");
    }
  }

  Future<void> signInWithEmail() async {
    state = state.copyWith(emailSigningIn: true, actionError: null);
    try {
      await _authService.signInWithEmail(
        email: state.emailController.text.trim(),
        password: state.passwordController.text,
      );
      state = state.copyWith(emailSigningIn: false, signInSuccess: true);
    } catch (error, stack) {
      FirebaseCrashlytics.instance
          .recordError(error, stack, reason: "Email Sign-In Error");
      state = state.copyWith(emailSigningIn: false, actionError: error);
      debugPrint("SignInViewNotifier: error in signInWithEmail -> $error");
    }
  }

  @override
  void dispose() {
    state.emailController.dispose();
    state.passwordController.dispose();
    super.dispose();
  }
}

@freezed
class SignInState with _$SignInState {
  const factory SignInState({
    required TextEditingController emailController,
    required TextEditingController passwordController,
    @Default(true) bool obscurePassword,
    @Default(false) bool enableBtn,
    @Default(false) bool googleSigningIn,
    @Default(false) bool emailSigningIn,
    @Default(false) bool signInSuccess,
    Object? actionError,
  }) = _SignInState;
}
