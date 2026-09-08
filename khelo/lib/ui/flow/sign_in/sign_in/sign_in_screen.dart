import 'package:cricheros_data/storage/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cricheros/components/app_page.dart';
import 'package:cricheros/components/error_snackbar.dart';
import 'package:cricheros/domain/extensions/context_extensions.dart';
import 'package:cricheros/ui/app_route.dart';
import 'package:cricheros/ui/flow/sign_in/sign_in/sign_in_view_model.dart';
import 'package:cricheros_style/button/bottom_sticky_overlay.dart';
import 'package:cricheros_style/button/primary_button.dart';
import 'package:cricheros_style/extensions/context_extensions.dart';
import 'package:cricheros_style/text/app_text_field.dart';
import 'package:cricheros_style/text/app_text_style.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(signInStateProvider.notifier);
    final state = ref.watch(signInStateProvider);

    _observeActionError(context, ref);
    _observeSignInSuccess(context, ref);

    final busy = state.googleSigningIn || state.emailSigningIn;

    return AppPage(
      title: "",
      body: Builder(builder: (context) {
        return ListView(
          padding: context.mediaQueryPadding +
              const EdgeInsets.symmetric(horizontal: 16) +
              BottomStickyOverlay.padding,
          children: [
            Text(
              context.l10n.sign_in_title,
              style: AppTextStyle.header1
                  .copyWith(color: context.colorScheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.sign_in_description,
              style: AppTextStyle.subtitle1
                  .copyWith(color: context.colorScheme.textDisabled),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              context.l10n.sign_in_continue_with_google,
              progress: state.googleSigningIn,
              enabled: !busy,
              background: Colors.white,
              foreground: Colors.black87,
              onPressed: notifier.signInWithGoogle,
            ),
            _orDivider(context),
            AppTextField(
              controller: state.emailController,
              enabled: !busy,
              keyboardType: TextInputType.emailAddress,
              hintText: context.l10n.sign_in_email_placeholder,
              backgroundColor: context.colorScheme.containerLowOnSurface,
              borderRadius: BorderRadius.circular(12),
              borderType: AppTextFieldBorderType.outline,
              borderColor: BorderColor(
                  focusColor: Colors.transparent, unFocusColor: Colors.transparent),
              contentPadding: const EdgeInsets.all(16),
              onChanged: (_) => notifier.onFieldChange(),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: state.passwordController,
              enabled: !busy,
              obscureText: state.obscurePassword,
              hintText: context.l10n.sign_in_password_placeholder,
              backgroundColor: context.colorScheme.containerLowOnSurface,
              borderRadius: BorderRadius.circular(12),
              borderType: AppTextFieldBorderType.outline,
              borderColor: BorderColor(
                  focusColor: Colors.transparent, unFocusColor: Colors.transparent),
              contentPadding: const EdgeInsets.all(16),
              suffixIcon: IconButton(
                icon: Icon(state.obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: notifier.toggleObscurePassword,
              ),
              onChanged: (_) => notifier.onFieldChange(),
              onSubmitted: (_) =>
                  (!busy && state.enableBtn) ? notifier.signInWithEmail() : null,
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              context.l10n.sign_in_btn_text,
              enabled: state.enableBtn && !busy,
              progress: state.emailSigningIn,
              onPressed: notifier.signInWithEmail,
            ),
            const SizedBox(height: 24),
            _signUpLink(context),
          ],
        );
      }),
    );
  }

  Widget _orDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Expanded(child: Divider(color: context.colorScheme.outline)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              context.l10n.sign_in_or_divider,
              style: AppTextStyle.body2
                  .copyWith(color: context.colorScheme.textDisabled),
            ),
          ),
          Expanded(child: Divider(color: context.colorScheme.outline)),
        ],
      ),
    );
  }

  Widget _signUpLink(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(
            context.l10n.sign_in_no_account_text,
            style: AppTextStyle.body2
                .copyWith(color: context.colorScheme.textDisabled),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => AppRoute.signUp.push(context),
            child: Text(
              context.l10n.sign_in_sign_up_link_text,
              style: AppTextStyle.body2
                  .copyWith(color: context.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _onSignInSuccess(BuildContext context, WidgetRef ref) {
    final user = ref.read(currentUserPod);
    if (user?.name == null || user!.name!.trim().isEmpty) {
      AppRoute.editProfile(isToCreateAccount: true).go(context);
    } else {
      AppRoute.main.go(context);
    }
  }

  void _observeActionError(BuildContext context, WidgetRef ref) {
    ref.listen(signInStateProvider.select((value) => value.actionError),
        (previous, next) {
      if (next != null) {
        showErrorSnackBar(context: context, error: next);
      }
    });
  }

  void _observeSignInSuccess(BuildContext context, WidgetRef ref) {
    ref.listen(signInStateProvider.select((value) => value.signInSuccess),
        (previous, next) {
      if (next && context.mounted) _onSignInSuccess(context, ref);
    });
  }
}
