import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_components/ui_components.dart';
import 'package:xoapp/src/common/extensions/build_context_extensions.dart';
import 'package:xoapp/src/presentation/widgets/animated_xo_logo.dart';
import 'package:xoapp/src/routing/app_routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: FractionallySizedBox(
                        widthFactor: 0.6,
                        child: const AnimatedXoLogo(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      l10n.appTitle,
                      style: context.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.welcomeSubtitle,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.brand.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              GradientButton(
                onPressed: () => context.go(AppRoutes.loginPath),
                icon: Icons.login,
                label: l10n.signInButton,
              ),
              const SizedBox(height: AppSpacing.sm),
              GradientButton.secondary(
                onPressed: () => context.go(AppRoutes.signUpPath),
                icon: Icons.person_add_outlined,
                label: l10n.createAccountButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
