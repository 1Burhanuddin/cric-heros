import 'package:cricheros/l10n/app_localizations.dart';
import 'package:cricheros_data/service/auth/auth_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_view_model.freezed.dart';

final signUpStateProvider =
    StateNotifierProvider.autoDispose<SignUpViewNotifier, SignUpState>((ref) {
  return SignUpViewNotifier(ref.read(authServiceProvider));
});

class SignUpViewNotifier extends StateNotifier<SignUpState> {
  final AuthService _authService;

  SignUpViewNotifier(this._authService)
      : super(
          SignUpState(
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
            confirmPasswordController: TextEditingController(),
          ),
        );

  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void toggleObscureConfirmPassword() {
    state = state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword);
  }

  void onFieldChange() {
    state = state.copyWith(
      enableBtn: state.emailController.text.trim().isNotEmpty &&
          state.passwordController.text.trim().isNotEmpty &&
          state.confirmPasswordController.text.trim().isNotEmpty,
    );
  }

  Future<void> signUp(AppLocalizations l10n) async {
    if (state.passwordController.text != state.confirmPasswordController.text) {
      state = state.copyWith(actionError: l10n.sign_up_password_mismatch_text);
      return;
    }

    state = state.copyWith(signingUp: true, actionError: null);
    try {
      await _authService.signUpWithEmail(
        email: state.emailController.text.trim(),
        password: state.passwordController.text,
      );
      state = state.copyWith(signingUp: false, signUpSuccess: true);
    } catch (error, stack) {
      FirebaseCrashlytics.instance
          .recordError(error, stack, reason: "Email Sign-Up Error");
      state = state.copyWith(signingUp: false, actionError: error);
      debugPrint("SignUpViewNotifier: error in signUp -> $error");
    }
  }

  @override
  void dispose() {
    state.emailController.dispose();
    state.passwordController.dispose();
    state.confirmPasswordController.dispose();
    super.dispose();
  }
}

@freezed
class SignUpState with _$SignUpState {
  const factory SignUpState({
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    @Default(true) bool obscurePassword,
    @Default(true) bool obscureConfirmPassword,
    @Default(false) bool enableBtn,
    @Default(false) bool signingUp,
    @Default(false) bool signUpSuccess,
    Object? actionError,
  }) = _SignUpState;
}
