import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────
/// PREMIUM DESIGN SYSTEM (INSURANCE APP)
/// ─────────────────────────────────────────────────────────

class AppColors {
  AppColors._();

  // Primary Palette
  static const Color primary = Color(0xFF002D7D);
  static const Color primaryLight = Color(0xFFE6EBF5);
  static const Color secondary = Color(0xFF96272A);
  static const Color accent = Color(0xFF7C5CFC);
  static const Color accentLight = Color(0xFFF1EEFF);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successBg = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFFFEF2F2);

  // Policy Specific
  static const Color healthPolicy = Color(0xFF10B981);
  static const Color lifePolicy = Color(0xFF002D7D);
  static const Color vehiclePolicy = Color(0xFFF59E0B);

  // Neutral Palette
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF3F4F6);

  // Legacy/Compatibility
  static const Color ctaEnabled = primary;
  static const Color ctaDisabled = Color(0xFF9CA3AF);
  static const Color borderFocused = primary;
  static const Color white = Colors.white;
  static const Color black = textPrimary;
  static const Color grey = textSecondary;
  static const Color lightGrey = border;
  static const Color disabled = Color(0xFF9CA3AF);

  // Utility Methods
  static Color getPolicyTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'health': return healthPolicy;
      case 'life': return lifePolicy;
      case 'vehicle': return vehiclePolicy;
      default: return primary;
    }
  }

  static IconData getPolicyTypeIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'health': return Icons.favorite_outline;
      case 'life': return Icons.person_outline;
      case 'vehicle': return Icons.directions_car_outlined;
      default: return Icons.shield_outlined;
    }
  }
}

class AppTextStyles {
  AppTextStyles._();

  static const String font = 'Inter';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: font,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: font,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: font,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: font,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: font,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: font,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: font,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: font,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: font,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    textBaseline: TextBaseline.alphabetic,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: font,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: font,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle linkText = TextStyle(
    fontFamily: font,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  // Legacy/Compatibility
  static const TextStyle heading = displayMedium;
  static const TextStyle subheading = bodyLarge;
  static const TextStyle input = bodyLarge;
  static const TextStyle button = buttonText;
  static const TextStyle link = linkText;
}

class AppRadius {
  AppRadius._();
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double full = 999.0;
}

class AppDimensions {
  AppDimensions._();
  static const double inputRadius = 8.0;
  static const double cardRadius = 28.0;
  static const double horizontalPadding = 24.0;
  static const double verticalPadding = 24.0;
}

class AppShadows {
  AppShadows._();
  static List<BoxShadow> get card => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get soft => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.03),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.titleLarge,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        textStyle: AppTextStyles.buttonText,
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      labelStyle: AppTextStyles.bodyMedium,
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
    ),
  );
}