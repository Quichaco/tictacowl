import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui_components/ui_components.dart';
import 'package:xoapp/src/common/extensions/build_context_extensions.dart';
import 'package:xoapp/src/routing/app_routes.dart';

class WelcomeScreen extends HookConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final l10n = context.l10n;

    ref.listen(userViewModelProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.saveUserError)),
        );
      }
      if (next.hasValue && !next.isLoading && next.value != null) {
        context.go(AppRoutes.home);
      }
    });

    void submit() {
      if (formKey.currentState?.validate() ?? false) {
        ref.read(userViewModelProvider.notifier).saveUser(nameController.text);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GradientText(
                  l10n.welcomeTitle,
                  style: context.textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.enterName,
                    counterText: '',
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  maxLength: User.maxNameLength,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: User.nameValidator(
                    l10n.nameMinLengthError(User.minNameLength),
                  ),
                  onFieldSubmitted: (_) => submit(),
                ),
                const SizedBox(height: AppSpacing.md),
                GradientButton(
                  onPressed: submit,
                  icon: Icons.arrow_forward,
                  label: l10n.continueButton,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
