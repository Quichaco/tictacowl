import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui_components/ui_components.dart';
import 'package:user_feature/src/navigation/user_navigator.dart';
import 'package:user_feature/src/presentation/l10n/user_l10n_extension.dart';
import 'package:user_feature/src/presentation/viewmodels/auth_viewmodel.dart';
import 'package:user_feature/src/presentation/widgets/auth_email_field.dart';

class ForgotPasswordScreen extends HookConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.userL10n;
    final navigator = ref.read(userNavigatorProvider);
    final emailController = useTextEditingController();
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final emailFocusNode = useFocusNode();
    final emailSent = useState<String?>(null);

    Future<void> submit() async {
      if (!(formKey.currentState?.validate() ?? false)) return;

      final email = emailController.text.trim();
      final result = await ref.read(authViewModelProvider.notifier).resetPassword(
            email: email,
          );

      if (!context.mounted) return;

      result.when(
        success: (_) => emailSent.value = email,
        failure: (e) => context.showErrorSnackBar(l10n.getErrorMessage(e)),
      );
    }

    if (emailSent.value != null) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.lg),
                Icon(
                  Icons.mark_email_read_outlined,
                  size: 80,
                  color: context.colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.resetLinkSentTitle,
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.resetLinkSentMessage(emailSent.value!),
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.brand.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                GradientButton(
                  onPressed: navigator.goToLogin,
                  label: l10n.backToLoginButton,
                  icon: Icons.arrow_back,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: XoAppBar(
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.lg),
                Icon(
                  Icons.lock_reset_outlined,
                  size: 80,
                  color: context.colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.forgotPasswordTitle,
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.forgotPasswordSubtitle,
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
                  onFieldSubmitted: (_) => submit(),
                ),
                const SizedBox(height: AppSpacing.md),
                GradientButton(
                  onPressed: submit,
                  label: l10n.sendResetLinkButton,
                  icon: Icons.send,
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: navigator.goToLogin,
                  child: Text(l10n.backToLoginButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
