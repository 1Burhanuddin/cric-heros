import 'package:cricheros_data/storage/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cricheros/components/app_page.dart';
import 'package:cricheros/components/error_snackbar.dart';
import 'package:cricheros/domain/extensions/context_extensions.dart';
import 'package:cricheros/ui/app_route.dart';
import 'package:cricheros/ui/flow/sign_in/sign_in/sign_in_view_model.dart';
import 'package:cricheros_style/animations/on_tap_scale.dart';
import 'package:cricheros_style/button/bottom_sticky_overlay.dart';
import 'package:cricheros_style/button/primary_button.dart';
import 'package:cricheros_style/extensions/context_extensions.dart';
import 'package:cricheros_style/indicator/progress_indicator.dart';
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
            const SizedBox(height: 24),
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
            _googleButton(context, state, busy, notifier),
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
                icon: SvgPicture.asset(
                  state.obscurePassword
                      ? 'assets/images/icons/ic_eye_slash.svg'
                      : 'assets/images/icons/ic_eye.svg',
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    context.colorScheme.textDisabled,
                    BlendMode.srcIn,
                  ),
                ),
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

  Widget _googleButton(
    BuildContext context,
    SignInState state,
    bool busy,
    SignInViewNotifier notifier,
  ) {
    final tappable = !state.googleSigningIn && !busy;
    return OnTapScale(
      onTap: notifier.signInWithGoogle,
      enabled: tappable,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 48),
        decoration: BoxDecoration(
          color: tappable ? Colors.white : Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: context.colorScheme.outline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.googleSigningIn) ...[
              const AppProgressIndicator(
                size: AppProgressIndicatorSize.small,
                color: Colors.black87,
              ),
              const SizedBox(width: 12),
            ] else ...[
              SvgPicture.asset('assets/images/icons/ic_google.svg', width: 20, height: 20),
              const SizedBox(width: 12),
            ],
            Text(
              context.l10n.sign_in_continue_with_google,
              style: AppTextStyle.button.copyWith(color: Colors.black87),
            ),
          ],
        ),
      ),
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
