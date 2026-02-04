import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ui_components/ui_components.dart';
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
    final userAsync = ref.watch(userViewModelProvider);
    final themeMode = ref.watch(themeViewModelProvider);
    final locale = ref.watch(localeViewModelProvider);

    final isEditingName = useState(false);
    final nameController = useTextEditingController(
      text: userAsync.value?.name ?? '',
    );
    final nameFormKey = useMemoized(GlobalKey<FormState>.new);
    final packageInfo = useFuture(
      useMemoized(PackageInfo.fromPlatform),
    );

    Future<void> submitName() async {
      await ref
          .read(userViewModelProvider.notifier)
          .saveUser(nameController.text);
      isEditingName.value = false;
    }

    return Scaffold(
      appBar: XoAppBar(title: l10n.settingsTitle),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            // Name section
            _SectionTitle(l10n.editName),
            const SizedBox(height: AppSpacing.xs),
            EditableField(
              value: userAsync.value?.name ?? '',
              isEditing: isEditingName.value,
              controller: nameController,
              formKey: nameFormKey,
              validator: User.nameValidator(
                l10n.nameMinLengthError(User.minNameLength),
              ),
              maxLength: User.maxNameLength,
              onSubmitted: submitName,
              onEditPressed: () {
                nameController.text = userAsync.value?.name ?? '';
                isEditingName.value = true;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            // Theme section
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
            const SizedBox(height: AppSpacing.md),
            // Language section
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
            const SizedBox(height: AppSpacing.xl),
            if (packageInfo.hasData)
              _AppInfo(version: packageInfo.data!.version),
          ],
        ),
      ),
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
