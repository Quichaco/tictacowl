import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary action button gradient
  static const Color actionStart = Color(0xFFa47b4c);
  static const Color actionEnd = Color(0xFFc9a070);

  // Player X gradient (orange/brown)
  static const Color playerXStart = Color(0xFFa63f03);
  static const Color playerXEnd = Color(0xFFe78621);

  // Player O / AI gradient (green)
  static const Color playerOStart = Color(0xFF3a5e00);
  static const Color playerOEnd = Color(0xFFa5d60d);

  // Background gradient - Light (beige tones)
  static const Color bgBaseLight = Color(0xFFFAF6F1);
  static const Color bgAccentLight = Color(0xFFEDE4D9);

  // Background gradient - Dark (dark brown tones)
  static const Color bgBaseDark = Color(0xFF141210);
  static const Color bgAccentDark = Color(0xFF261F1A);

  // Secondary text
  static const Color textSecondaryLight = Color(0xFF7A6B5E);
  static const Color textSecondaryDark = Color(0xFFA89888);

  // Game mode gradients
  static const Color multiplayerStart = Color(0xFF667eea);
  static const Color multiplayerEnd = Color(0xFF764ba2);
  static const Color easyStart = Color(0xFF56AB2F);
  static const Color easyEnd = Color(0xFFA8E063);
  static const Color mediumStart = Color(0xFFE65C00);
  static const Color mediumEnd = Color(0xFFF9D423);
  static const Color hardStart = Color(0xFFC62828);
  static const Color hardEnd = Color(0xFFE57373);

  // Feedback colors
  static const Color gold = Color(0xFFFFD700);
}
