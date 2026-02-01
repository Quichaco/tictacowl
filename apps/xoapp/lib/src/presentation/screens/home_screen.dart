import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xoapp/src/common/extensions/build_context_extensions.dart';
import 'package:xoapp/src/presentation/viewmodels/user_viewmodel.dart';
import 'package:xoapp/theme/app_spacing.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final userAsync = ref.watch(userViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: Center(
        child: userAsync.when(
          data: (user) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user != null
                    ? l10n.homeGreeting(user.name)
                    : l10n.homeGreetingFallback,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton.icon(
                onPressed: () {
                  // TODO: navigate to game screen
                },
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.playButton),
              ),
            ],
          ),
          loading: () => const CircularProgressIndicator(),
          error: (error, _) => Text(l10n.genericError),
        ),
      ),
    );
  }
}
