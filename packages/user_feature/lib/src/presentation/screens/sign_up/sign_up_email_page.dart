import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';
import 'package:user_feature/src/presentation/l10n/user_l10n_extension.dart';
import 'package:user_feature/src/presentation/widgets/auth_email_field.dart';

class SignUpEmailPage extends StatelessWidget {
  const SignUpEmailPage({
    required this.formKey,
    required this.emailController,
    required this.emailFocusNode,
    required this.onSubmit,
    required this.onGoToLogin,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final FocusNode emailFocusNode;
  final VoidCallback onSubmit;
  final VoidCallback onGoToLogin;

  @override
  Widget build(BuildContext context) {
    final l10n = context.userL10n;

    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.signUpTitle,
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.signUpEmailSubtitle,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.brand.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            AuthEmailField(
              controller: emailController,
              labelText: l10n.emailLabel,
              hintText: l10n.emailHint,
              invalidErrorText: l10n.emailInvalidError,
              focusNode: emailFocusNode,
              onFieldSubmitted: (_) => onSubmit(),
            ),
            const SizedBox(height: AppSpacing.sm),
            GradientButton(
              onPressed: onSubmit,
              label: l10n.continueButton,
              icon: Icons.arrow_forward,
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.alreadyHaveAccountText,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.brand.textSecondary,
                  ),
                ),
                TextButton(
                  onPressed: onGoToLogin,
                  child: Text(l10n.signInLink),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
