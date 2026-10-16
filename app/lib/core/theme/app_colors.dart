import 'package:flutter/material.dart';

/// Brand palette — design direction (ก): deep navy + peach accent.
///
/// Colors are declared as raw tokens here and mapped into [ColorScheme]s in
/// [AppTheme]. Never reference these constants directly in widgets — always go
/// through `Theme.of(context).colorScheme` so dark mode & theming stay
/// consistent.
abstract final class AppColors {
  // Core brand
  static const navy = Color(0xFF0E1B2C); // Primary surface / brand ink
  static const navy700 = Color(0xFF16283F);
  static const navy500 = Color(0xFF24405F);
  static const peach = Color(0xFFFF7A45); // Accent / calls-to-action
  static const peach300 = Color(0xFFFFB088);

  // Semantic
  static const success = Color(0xFF1FB57A);
  static const warning = Color(0xFFF2B33D);
  static const danger = Color(0xFFE5484D);

  // Neutrals (light)
  static const cloud = Color(0xFFF6F8FB); // App background (light)
  static const surfaceLight = Color(0xFFFFFFFF);
  static const inkLight = Color(0xFF0E1B2C);
  static const mutedLight = Color(0xFF5C6B7F);

  // Neutrals (dark)
  static const surfaceDark = Color(0xFF16283F);
  static const bgDark = Color(0xFF0B1521);
  static const inkDark = Color(0xFFEAF0F7);
  static const mutedDark = Color(0xFF9AAAC0);
}
