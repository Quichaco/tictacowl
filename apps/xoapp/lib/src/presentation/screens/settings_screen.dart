import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui_components/ui_components.dart';
import 'package:xoapp/l10n/gen/app_localizations.dart';
import 'package:xoapp/src/common/extensions/build_context_extensions.dart';
import 'package:xoapp/src/common/extensions/locale_extensions.dart';
import 'package:xoapp/src/common/extensions/theme_mode_extensions.dart';
import 'package:xoapp/src/presentation/viewmodels/locale_viewmodel.dart';
import 'package:xoapp/src/presentation/viewmodels/theme_viewmodel.dart';
import 'package:xoapp/src/presentation/viewmodels/user_viewmodel.dart';

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

    void submitName() async {
      await ref
          .read(userViewModelProvider.notifier)
          .saveUser(nameController.text);
      isEditingName.value = false;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          // Name section
          _SectionTitle(l10n.editName),
          const SizedBox(height: AppSpacing.xs),
          EditableField(
            value: userAsync.value?.name ?? '',
            isEditing: isEditingName.value,
            controller: nameController,
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
        ],
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
