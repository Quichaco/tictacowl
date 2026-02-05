import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui_components/ui_components.dart';
import 'package:user_domain/user_domain.dart';
import 'package:user_feature/src/presentation/l10n/user_l10n_extension.dart';
import 'package:user_feature/src/presentation/viewmodels/user_viewmodel.dart';

class SetUsernameScreen extends HookConsumerWidget {
  const SetUsernameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.userL10n;
    final nameController = useTextEditingController();
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final nameFocusNode = useFocusNode();

    Future<void> submit() async {
      if (!(formKey.currentState?.validate() ?? false)) return;

      final result = await ref
          .read(userViewModelProvider.notifier)
          .saveProfile(nameController.text);

      if (!context.mounted) return;

      result.when(
        success: (_) {},
        failure: (e) => context.showErrorSnackBar(l10n.getErrorMessage(e)),
      );
      // Navigation handled by router redirect
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.xl * 2),
                Icon(
                  Icons.person_outline,
                  size: 80,
                  color: context.colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n.setUsernameTitle,
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.setUsernameSubtitle,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.brand.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                TextFormField(
                  controller: nameController,
                  focusNode: nameFocusNode,
                  decoration: InputDecoration(
                    labelText: l10n.usernameLabel,
                    hintText: l10n.usernameHint,
                    prefixIcon: const Icon(Icons.badge_outlined),
                    counterText: '',
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  maxLength: Validators.maxNameLength,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (v) => Validators.name(
                    v,
                    tooShortMessage:
                        l10n.nameTooShortError(Validators.minNameLength),
                    tooLongMessage:
                        l10n.nameTooLongError(Validators.maxNameLength),
                  ),
                  onFieldSubmitted: (_) => submit(),
                ),
                const SizedBox(height: AppSpacing.md),
                GradientButton(
                  onPressed: submit,
                  label: l10n.letsGoButton,
                  icon: Icons.arrow_forward,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
