import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui_components/ui_components.dart';
import 'package:user_domain/user_domain.dart';
import 'package:user_feature/src/navigation/user_navigator.dart';
import 'package:user_feature/src/presentation/l10n/user_l10n_extension.dart';
import 'package:user_feature/src/presentation/viewmodels/auth_viewmodel.dart';
import 'package:user_feature/src/presentation/widgets/auth_email_field.dart';
import 'package:user_feature/src/presentation/widgets/auth_password_field.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.userL10n;
    final navigator = ref.read(userNavigatorProvider);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final emailFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();

    Future<void> submit() async {
      if (!(formKey.currentState?.validate() ?? false)) return;

      final result = await ref.read(authViewModelProvider.notifier).signIn(
            email: emailController.text,
            password: passwordController.text,
          );

      if (!context.mounted) return;

      result.when(
        success: (_) => TextInput.finishAutofillContext(),
        failure: (e) => context.showErrorSnackBar(l10n.getErrorMessage(e)),
      );
    }

    return Scaffold(
      appBar: XoAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: AutofillGroup(
            child: Form(
              key: formKey,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.md),
                Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: context.colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.loginTitle,
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.loginSubtitle,
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
                  onFieldSubmitted: (_) => passwordFocusNode.requestFocus(),
                ),
                const SizedBox(height: AppSpacing.sm),
                AuthPasswordField(
                  controller: passwordController,
                  labelText: l10n.passwordLabel,
                  hintText: l10n.passwordHint,
                  tooShortErrorText:
                      l10n.passwordTooShortError(Validators.minPasswordLength),
                  focusNode: passwordFocusNode,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => submit(),
                ),
                const SizedBox(height: AppSpacing.xs),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: navigator.goToForgotPassword,
                    child: Text(l10n.forgotPasswordButton),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                GradientButton(
                  onPressed: submit,
                  label: l10n.signInButton,
                  icon: Icons.login,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.noAccountText,
                      style: context.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: navigator.goToSignUp,
                      child: Text(l10n.signUpLink),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}
