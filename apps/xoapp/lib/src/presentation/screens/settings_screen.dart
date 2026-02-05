import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ui_components/ui_components.dart';
import 'package:user_domain/user_domain.dart';
import 'package:user_feature/user_feature.dart';
import 'package:xoapp/l10n/gen/app_localizations.dart';
import 'package:xoapp/src/common/constants/app_assets.dart';
import 'package:xoapp/src/common/extensions/build_context_extensions.dart';
import 'package:xoapp/src/common/extensions/locale_extensions.dart';
import 'package:xoapp/src/common/extensions/theme_mode_extensions.dart';
import 'package:xoapp/src/presentation/viewmodels/locale_viewmodel.dart';
import 'package:xoapp/src/presentation/viewmodels/theme_viewmodel.dart';

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final packageInfo = useFuture(
      useMemoized(PackageInfo.fromPlatform),
    );

    Future<void> signOut() async {
      final result = await ref.read(authViewModelProvider.notifier).signOut();

      if (!context.mounted) return;

      if (result.isFailure) {
        context.showErrorSnackBar(l10n.genericError);
      }
    }

    return Scaffold(
      appBar: XoAppBar(title: l10n.settingsTitle),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            const _NameSection(),
            const SizedBox(height: AppSpacing.md),
            const _ThemeSection(),
            const SizedBox(height: AppSpacing.md),
            const _LanguageSection(),
            const SizedBox(height: AppSpacing.md),
            _LogoutButton(onPressed: signOut),
            const SizedBox(height: AppSpacing.xl),
            if (packageInfo.hasData)
              _AppInfo(version: packageInfo.data!.version),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _NameSection extends HookConsumerWidget {
  const _NameSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(userViewModelProvider).value;

    final isEditing = useState(false);
    final controller = useTextEditingController(text: user?.name ?? '');
    final formKey = useMemoized(GlobalKey<FormState>.new);

    Future<void> submit() async {
      if (!(formKey.currentState?.validate() ?? false)) return;

      final result = await ref
          .read(userViewModelProvider.notifier)
          .saveProfile(controller.text);

      if (!context.mounted) return;

      result.when(
        success: (_) => isEditing.value = false,
        failure: (_) => context.showErrorSnackBar(l10n.saveUserError),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(l10n.editName),
        const SizedBox(height: AppSpacing.xs),
        EditableField(
          value: user?.name ?? '',
          isEditing: isEditing.value,
          controller: controller,
          formKey: formKey,
          validator: (v) => Validators.name(
            v,
            tooShortMessage: l10n.nameMinLengthError(Validators.minNameLength),
            tooLongMessage: l10n.nameTooLongError(Validators.maxNameLength),
          ),
          maxLength: Validators.maxNameLength,
          onSubmitted: submit,
          onEditPressed: () {
            controller.text = user?.name ?? '';
            isEditing.value = true;
          },
        ),
      ],
    );
  }
}

class _ThemeSection extends ConsumerWidget {
  const _ThemeSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final themeMode = ref.watch(themeViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(l10n.themeLabel),
        const SizedBox(height: AppSpacing.xs),
        SelectField<ThemeMode>(
          title: l10n.themeLabel,
          values: ThemeMode.values,
          selected: themeMode,
          labelOf: (m) => m.label(l10n),
          iconOf: (m) => m.icon,
          onSelected: (m) =>
              ref.read(themeViewModelProvider.notifier).setThemeMode(m),
        ),
      ],
    );
  }
}

class _LanguageSection extends ConsumerWidget {
  const _LanguageSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = ref.watch(localeViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(l10n.languageLabel),
        const SizedBox(height: AppSpacing.xs),
        SelectField<Locale>(
          title: l10n.languageLabel,
          values: AppLocalizations.supportedLocales,
          selected: locale ?? AppLocalizations.supportedLocales.first,
          labelOf: (l) => l.nativeName,
          iconOf: (_) => Icons.translate,
          onSelected: (l) =>
              ref.read(localeViewModelProvider.notifier).setLocale(l),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.titleSmall?.copyWith(
        color: context.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _AppInfo extends StatelessWidget {
  const _AppInfo({required this.version});
  final String version;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          AppAssets.xoLogo,
          height: 48,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          context.l10n.versionLabel(version),
          style: context.textTheme.bodySmall?.copyWith(
            color: context.brand.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: context.colorScheme.error,
        side: BorderSide(color: context.colorScheme.error.withValues(alpha: 0.5)),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
        ),
      ),
      icon: const Icon(Icons.logout),
      label: Text(context.l10n.logoutButton),
    );
  }
}
