import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ui_components/ui_components.dart';
import 'package:user_domain/user_domain.dart';
import 'package:user_feature/src/presentation/l10n/user_l10n_extension.dart';
import 'package:user_feature/src/presentation/widgets/auth_password_field.dart';

class SignUpPasswordPage extends HookWidget {
  const SignUpPasswordPage({
    required this.formKey,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.passwordFocusNode,
    required this.confirmPasswordFocusNode,
    required this.onSubmit,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FocusNode passwordFocusNode;
  final FocusNode confirmPasswordFocusNode;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.userL10n;
    final confirmPasswordVisible = useState(false);

    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.signUpPasswordTitle,
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.signUpPasswordSubtitle,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.brand.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            AuthPasswordField(
              controller: passwordController,
              labelText: l10n.passwordLabel,
              hintText: l10n.passwordHint,
              tooShortErrorText:
                  l10n.passwordTooShortError(Validators.minPasswordLength),
              focusNode: passwordFocusNode,
              textInputAction: TextInputAction.next,
              isNewPassword: true,
              onFieldSubmitted: (_) => confirmPasswordFocusNode.requestFocus(),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: confirmPasswordController,
              focusNode: confirmPasswordFocusNode,
              decoration: InputDecoration(
                labelText: l10n.confirmPasswordLabel,
                hintText: l10n.confirmPasswordHint,
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    confirmPasswordVisible.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () =>
                      confirmPasswordVisible.value = !confirmPasswordVisible.value,
                ),
              ),
              obscureText: !confirmPasswordVisible.value,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.confirmPasswordRequiredError;
                }
                if (value != passwordController.text) {
                  return l10n.passwordsDoNotMatchError;
                }
                return null;
              },
              onFieldSubmitted: (_) => onSubmit(),
            ),
            const SizedBox(height: AppSpacing.md),
            GradientButton(
              onPressed: onSubmit,
              label: l10n.createAccountButton,
              icon: Icons.check,
            ),
          ],
        ),
      ),
    );
  }
}
