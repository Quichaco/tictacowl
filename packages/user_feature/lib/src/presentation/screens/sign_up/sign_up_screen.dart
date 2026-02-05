import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui_components/ui_components.dart';
import 'package:user_feature/src/navigation/user_navigator.dart';
import 'package:user_feature/src/presentation/l10n/user_l10n_extension.dart';
import 'package:user_feature/src/presentation/screens/sign_up/sign_up_email_page.dart';
import 'package:user_feature/src/presentation/screens/sign_up/sign_up_password_page.dart';
import 'package:user_feature/src/presentation/viewmodels/auth_viewmodel.dart';

class SignUpScreen extends HookConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.userL10n;
    final navigator = ref.read(userNavigatorProvider);
    final pageController = usePageController();
    final currentPage = useState(0);

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    final emailFormKey = useMemoized(GlobalKey<FormState>.new);
    final passwordFormKey = useMemoized(GlobalKey<FormState>.new);

    final emailFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();
    final confirmPasswordFocusNode = useFocusNode();

    void goToNextPage() {
      pageController.nextPage(
        duration: AppDurations.medium,
        curve: Curves.easeInOut,
      );
    }

    void goToPreviousPage() {
      pageController.previousPage(
        duration: AppDurations.medium,
        curve: Curves.easeInOut,
      );
    }

    void submitEmail() {
      if (emailFormKey.currentState?.validate() ?? false) {
        goToNextPage();
      }
    }

    Future<void> submitPassword() async {
      if (!(passwordFormKey.currentState?.validate() ?? false)) return;

      final result = await ref.read(authViewModelProvider.notifier).signUp(
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
        child: AutofillGroup(
          child: Column(
          children: [
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md
              ),
              child: Row(
                children: [
                  Expanded(child: _ProgressDot(isActive: currentPage.value >= 0)),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(child: _ProgressDot(isActive: currentPage.value >= 1)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => currentPage.value = page,
                children: [
                  SignUpEmailPage(
                    formKey: emailFormKey,
                    emailController: emailController,
                    emailFocusNode: emailFocusNode,
                    onSubmit: submitEmail,
                    onGoToLogin: navigator.goToLogin,
                  ),
                  SignUpPasswordPage(
                    formKey: passwordFormKey,
                    passwordController: passwordController,
                    confirmPasswordController: confirmPasswordController,
                    passwordFocusNode: passwordFocusNode,
                    confirmPasswordFocusNode: confirmPasswordFocusNode,
                    onSubmit: submitPassword,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

class _ProgressDot extends StatelessWidget {
  const _ProgressDot({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.fast,
      height: 4,
      decoration: BoxDecoration(
        color: isActive
            ? context.colorScheme.primary
            : context.colorScheme.outline.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
