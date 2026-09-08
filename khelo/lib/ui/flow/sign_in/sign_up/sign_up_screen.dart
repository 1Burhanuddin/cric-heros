import 'package:cricheros_data/storage/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:cricheros/components/app_page.dart';
import 'package:cricheros/components/error_snackbar.dart';
import 'package:cricheros/domain/extensions/context_extensions.dart';
import 'package:cricheros/ui/app_route.dart';
import 'package:cricheros/ui/flow/sign_in/sign_up/sign_up_view_model.dart';
import 'package:cricheros_style/button/bottom_sticky_overlay.dart';
import 'package:cricheros_style/button/primary_button.dart';
import 'package:cricheros_style/extensions/context_extensions.dart';
import 'package:cricheros_style/text/app_text_field.dart';
import 'package:cricheros_style/text/app_text_style.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(signUpStateProvider.notifier);
    final state = ref.watch(signUpStateProvider);

    _observeActionError(context, ref);
    _observeSignUpSuccess(context, ref);

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
              context.l10n.sign_up_title,
              style: AppTextStyle.header1
                  .copyWith(color: context.colorScheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.sign_up_description,
              style: AppTextStyle.subtitle1
                  .copyWith(color: context.colorScheme.textDisabled),
            ),
            const SizedBox(height: 32),
            AppTextField(
              controller: state.emailController,
              enabled: !state.signingUp,
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
              enabled: !state.signingUp,
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
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: state.confirmPasswordController,
              enabled: !state.signingUp,
              obscureText: state.obscureConfirmPassword,
              hintText: context.l10n.sign_up_confirm_password_placeholder,
              backgroundColor: context.colorScheme.containerLowOnSurface,
              borderRadius: BorderRadius.circular(12),
              borderType: AppTextFieldBorderType.outline,
              borderColor: BorderColor(
                  focusColor: Colors.transparent, unFocusColor: Colors.transparent),
              contentPadding: const EdgeInsets.all(16),
              suffixIcon: IconButton(
                icon: SvgPicture.asset(
                  state.obscureConfirmPassword
                      ? 'assets/images/icons/ic_eye_slash.svg'
                      : 'assets/images/icons/ic_eye.svg',
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    context.colorScheme.textDisabled,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: notifier.toggleObscureConfirmPassword,
              ),
              onChanged: (_) => notifier.onFieldChange(),
              onSubmitted: (_) => (!state.signingUp && state.enableBtn)
                  ? notifier.signUp(context.l10n)
                  : null,
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              context.l10n.sign_up_btn_text,
              enabled: state.enableBtn && !state.signingUp,
              progress: state.signingUp,
              onPressed: () => notifier.signUp(context.l10n),
            ),
            const SizedBox(height: 24),
            _signInLink(context),
          ],
        );
      }),
    );
  }

  Widget _signInLink(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(
            context.l10n.sign_up_have_account_text,
            style: AppTextStyle.body2
                .copyWith(color: context.colorScheme.textDisabled),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => context.pop(),
            child: Text(
              context.l10n.sign_up_sign_in_link_text,
              style: AppTextStyle.body2
                  .copyWith(color: context.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _onSignUpSuccess(BuildContext context, WidgetRef ref) {
    final user = ref.read(currentUserPod);
    if (user?.name == null || user!.name!.trim().isEmpty) {
      AppRoute.editProfile(isToCreateAccount: true).go(context);
    } else {
      AppRoute.main.go(context);
    }
  }

  void _observeActionError(BuildContext context, WidgetRef ref) {
    ref.listen(signUpStateProvider.select((value) => value.actionError),
        (previous, next) {
      if (next != null) {
        showErrorSnackBar(context: context, error: next);
      }
    });
  }

  void _observeSignUpSuccess(BuildContext context, WidgetRef ref) {
    ref.listen(signUpStateProvider.select((value) => value.signUpSuccess),
        (previous, next) {
      if (next && context.mounted) _onSignUpSuccess(context, ref);
    });
  }
}
