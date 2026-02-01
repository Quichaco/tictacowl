import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xoapp/src/common/extensions/build_context_extensions.dart';
import 'package:xoapp/src/presentation/viewmodels/user_viewmodel.dart';
import 'package:xoapp/src/routing/app_routes.dart';
import 'package:xoapp/theme/app_spacing.dart';

class WelcomeScreen extends HookConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final l10n = context.l10n;
    final userState = ref.watch(userViewModelProvider);
    final isLoading = userState.isLoading;

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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.welcomeTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.enterName,
                ),
                textInputAction: TextInputAction.done,
                maxLength: 30,
                enabled: !isLoading,
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          ref
                              .read(userViewModelProvider.notifier)
                              .saveUser(nameController.text);
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.continueButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
