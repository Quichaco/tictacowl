import 'package:flutter/material.dart';
import 'package:ui_components/src/theme/app_colors.dart';

class BrandTheme extends ThemeExtension<BrandTheme> {
  const BrandTheme({
    required this.actionGradient,
    required this.secondaryGradient,
    required this.tertiaryGradient,
    required this.backgroundGradient,
    required this.textSecondary,
    required this.multiplayerGradient,
    required this.easyGradient,
    required this.mediumGradient,
    required this.hardGradient,
    required this.gold,
  });

  final LinearGradient actionGradient;
  final LinearGradient secondaryGradient;
  final LinearGradient tertiaryGradient;
  final LinearGradient backgroundGradient;
  final Color textSecondary;
  final LinearGradient multiplayerGradient;
  final LinearGradient easyGradient;
  final LinearGradient mediumGradient;
  final LinearGradient hardGradient;
  final Color gold;

  static const light = BrandTheme(
    actionGradient: LinearGradient(
      colors: [AppColors.actionStart, AppColors.actionEnd],
    ),
    secondaryGradient: LinearGradient(
      colors: [AppColors.playerXStart, AppColors.playerXEnd],
    ),
    tertiaryGradient: LinearGradient(
      colors: [AppColors.playerOStart, AppColors.playerOEnd],
    ),
    backgroundGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.bgBaseLight,
        AppColors.bgAccentLight,
        AppColors.bgBaseLight,
      ],
      stops: [0.0, 0.5, 1.0],
    ),
    textSecondary: AppColors.textSecondaryLight,
    multiplayerGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.multiplayerStart, AppColors.multiplayerEnd],
    ),
    easyGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.easyStart, AppColors.easyEnd],
    ),
    mediumGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.mediumStart, AppColors.mediumEnd],
    ),
    hardGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.hardStart, AppColors.hardEnd],
    ),
    gold: AppColors.gold,
  );

  static const dark = BrandTheme(
    actionGradient: LinearGradient(
      colors: [AppColors.actionEnd, AppColors.actionStart],
    ),
    secondaryGradient: LinearGradient(
      colors: [AppColors.playerXEnd, AppColors.playerXStart],
    ),
    tertiaryGradient: LinearGradient(
      colors: [AppColors.playerOEnd, AppColors.playerOStart],
    ),
    backgroundGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.bgBaseDark,
        AppColors.bgAccentDark,
        AppColors.bgBaseDark,
      ],
      stops: [0.0, 0.5, 1.0],
    ),
    textSecondary: AppColors.textSecondaryDark,
    multiplayerGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.multiplayerEnd, AppColors.multiplayerStart],
    ),
    easyGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.easyEnd, AppColors.easyStart],
    ),
    mediumGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.mediumEnd, AppColors.mediumStart],
    ),
    hardGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.hardEnd, AppColors.hardStart],
    ),
    gold: AppColors.gold,
  );

  @override
  BrandTheme copyWith({
    LinearGradient? actionGradient,
    LinearGradient? secondaryGradient,
    LinearGradient? tertiaryGradient,
    LinearGradient? backgroundGradient,
    Color? textSecondary,
    LinearGradient? multiplayerGradient,
    LinearGradient? easyGradient,
    LinearGradient? mediumGradient,
    LinearGradient? hardGradient,
    Color? gold,
  }) {
    return BrandTheme(
      actionGradient: actionGradient ?? this.actionGradient,
      secondaryGradient: secondaryGradient ?? this.secondaryGradient,
      tertiaryGradient: tertiaryGradient ?? this.tertiaryGradient,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      textSecondary: textSecondary ?? this.textSecondary,
      multiplayerGradient: multiplayerGradient ?? this.multiplayerGradient,
      easyGradient: easyGradient ?? this.easyGradient,
      mediumGradient: mediumGradient ?? this.mediumGradient,
      hardGradient: hardGradient ?? this.hardGradient,
      gold: gold ?? this.gold,
    );
  }

  @override
  BrandTheme lerp(BrandTheme? other, double t) {
    if (other == null) return this;
    return BrandTheme(
      actionGradient:
          LinearGradient.lerp(actionGradient, other.actionGradient, t)!,
      secondaryGradient:
          LinearGradient.lerp(secondaryGradient, other.secondaryGradient, t)!,
      tertiaryGradient:
          LinearGradient.lerp(tertiaryGradient, other.tertiaryGradient, t)!,
      backgroundGradient:
          LinearGradient.lerp(backgroundGradient, other.backgroundGradient, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      multiplayerGradient:
          LinearGradient.lerp(multiplayerGradient, other.multiplayerGradient, t)!,
      easyGradient:
          LinearGradient.lerp(easyGradient, other.easyGradient, t)!,
      mediumGradient:
          LinearGradient.lerp(mediumGradient, other.mediumGradient, t)!,
      hardGradient:
          LinearGradient.lerp(hardGradient, other.hardGradient, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
    );
  }
}
