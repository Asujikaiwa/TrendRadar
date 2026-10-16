import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Central Material 3 theme for TrendRadar (design direction ก).
///
/// Typography uses IBM Plex Sans Thai, which renders Thai, Latin and (with
/// fallback) CJK glyphs cleanly — matching our th/en/zh localization targets.
abstract final class AppTheme {
  static const _radius = 16.0;

  static ThemeData light() => _base(Brightness.light);
  static ThemeData dark() => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.navy,
      brightness: brightness,
      primary: isDark ? AppColors.peach300 : AppColors.navy,
      secondary: AppColors.peach,
      surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      error: AppColors.danger,
    );

    // Apply IBM Plex Sans Thai across the whole text theme.
    final baseText = ThemeData(brightness: brightness).textTheme;
    final textTheme = GoogleFonts.ibmPlexSansThaiTextTheme(baseText).apply(
      bodyColor: isDark ? AppColors.inkDark : AppColors.inkLight,
      displayColor: isDark ? AppColors.inkDark : AppColors.inkLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark ? AppColors.bgDark : AppColors.cloud,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.bgDark : AppColors.cloud,
        foregroundColor: isDark ? AppColors.inkDark : AppColors.inkLight,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
          side: BorderSide(
            color: (isDark ? AppColors.inkDark : AppColors.navy)
                .withValues(alpha: 0.06),
          ),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.peach,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52), // >= 48dp touch target
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        side: BorderSide.none,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor:
            isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        indicatorColor: AppColors.peach.withValues(alpha: 0.16),
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        height: 68,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.bgDark : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide(
            color: (isDark ? AppColors.inkDark : AppColors.navy)
                .withValues(alpha: 0.10),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide(
            color: (isDark ? AppColors.inkDark : AppColors.navy)
                .withValues(alpha: 0.10),
          ),
        ),
      ),
    );
  }
}
