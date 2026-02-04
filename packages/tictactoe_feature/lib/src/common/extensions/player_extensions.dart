import 'package:flutter/material.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:ui_components/ui_components.dart';

extension PlayerExtensions on Player {
  LinearGradient gradient(BuildContext context) {
    return this == Player.x
        ? context.brand.secondaryGradient
        : context.brand.tertiaryGradient;
  }
}
