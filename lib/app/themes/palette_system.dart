import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Professional Design System for Student Portal
/// Follows Material Design 3 principles with custom branding
class AppDesignSystem {
  // === RESPONSIVE BREAKPOINTS ===
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // === COLOR PALETTE ===
  // Primary Colors - Deep Blue Academic Theme
  static const Color primaryDark = Color(0xFF0F172A); // Rich Navy
  static const Color primary = Color(0xFF1E40AF); // Professional Blue
  static const Color primaryLight = Color(0xFF3B82F6); // Bright Blue
  static const Color primarySoft = Color(0xFFDBEAFE); // Light Blue Tint

  // Secondary Colors - Warm Academic Accents
  static const Color secondary = Color(0xFF7C3AED); // Academic Purple
  static const Color secondaryLight = Color(0xFFA855F7); // Light Purple
  static const Color accent = Color(0xFFEAB308); // Gold Accent
  static const Color accentLight = Color(0xFFFEF3C7); // Light Gold

  // Success & Status Colors
  static const Color success = Color(0xFF10B981); // Emerald Green
  static const Color successLight = Color(0xFFD1FAE5); // Light Green
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color warningLight = Color(0xFFFEF3C7); // Light Amber
  static const Color error = Color(0xFFEF4444); // Red
  static const Color errorLight = Color(0xFFFEE2E2); // Light Red
  static const Color info = Color(0xFF3B82F6); // Blue
  static const Color infoLight = Color(0xFFDBEAFE); // Light Blue

  // Neutral Colors - Professional Grays
  static const Color surfaceDark = Color(0xFF0F172A); // Dark Surface
  static const Color surface = Color(0xFFFAFAFA); // Light Surface
  static const Color surfaceContainer = Color(0xFFFFFFFF); // White Container
  static const Color surfaceVariant = Color(0xFFF1F5F9); // Light Gray

  static const Color textPrimary = Color(0xFF0F172A); // Dark Text
  static const Color textSecondary = Color(0xFF64748B); // Medium Gray
  static const Color textTertiary = Color(0xFF94A3B8); // Light Gray
  static const Color textInverse = Color(0xFFFFFFFF); // White Text

  static const Color border = Color(0xFFE2E8F0); // Light Border
  static const Color borderVariant = Color(0xFFCBD5E1); // Medium Border
  static const Color divider = Color(0xFFF1F5F9); // Subtle Divider

  // === GRADIENTS ===
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, Color(0xFFFBBF24)],
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFAFAFA), Color(0xFFF8FAFC)],
  );

  // === RESPONSIVE SPACING ===
  static double spacing(BuildContext context, double baseSize) {
    return baseSize * _getScaleFactor(context);
  }

  static double _getScaleFactor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) return 0.9;
    if (width < tabletBreakpoint) return 1.0;
    if (width < desktopBreakpoint) return 1.1;
    return 1.2;
  }

  // === RESPONSIVE DIMENSIONS ===
  static double responsiveRadius(BuildContext context, double baseRadius) {
    return baseRadius * _getScaleFactor(context);
  }

  static double responsiveSize(BuildContext context, double baseSize) {
    return baseSize * _getScaleFactor(context);
  }

  static EdgeInsets responsivePadding(
    BuildContext context, {
    double horizontal = 16,
    double vertical = 16,
    double? all,
  }) {
    final scale = _getScaleFactor(context);
    if (all != null) {
      return EdgeInsets.all(all * scale);
    }
    return EdgeInsets.symmetric(
      horizontal: horizontal * scale,
      vertical: vertical * scale,
    );
  }

  // === TYPOGRAPHY ===
  static TextTheme textTheme(BuildContext context) {
    final scale = _getScaleFactor(context);
    return GoogleFonts.interTextTheme().copyWith(
      // Display Styles
      displayLarge: GoogleFonts.inter(
        fontSize: 34 * scale,
        fontWeight: FontWeight.w800,
        color: textPrimary,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 30 * scale,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.3,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 26 * scale,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.3,
      ),

      // Headline Styles
      headlineLarge: GoogleFonts.inter(
        fontSize: 24 * scale,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 20 * scale,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 18 * scale,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      ),

      // Title Styles
      titleLarge: GoogleFonts.inter(
        fontSize: 18 * scale,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.5,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16 * scale,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.5,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14 * scale,
        fontWeight: FontWeight.w600,
        color: textSecondary,
        height: 1.5,
      ),

      // Body Styles
      bodyLarge: GoogleFonts.inter(
        fontSize: 18 * scale,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 16 * scale,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.6,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 14 * scale,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.6,
      ),

      // Label Styles
      labelLarge: GoogleFonts.inter(
        fontSize: 16 * scale,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        height: 1.4,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 14 * scale,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        height: 1.4,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 12 * scale,
        fontWeight: FontWeight.w500,
        color: textTertiary,
        height: 1.4,
      ),
    );
  }

  // === SHADOWS ===
  static List<BoxShadow> elevation(int level) {
    switch (level) {
      case 1:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ];
      case 2:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ];
      case 3:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ];
      case 4:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 6),
            blurRadius: 18,
          ),
        ];
      default:
        return [];
    }
  }

  // === COMPONENT STYLES ===
  static BoxDecoration cardDecoration(
    BuildContext context, {
    int elevation = 2,
  }) {
    return BoxDecoration(
      color: surfaceContainer,
      borderRadius: BorderRadius.circular(responsiveRadius(context, 16)),
      boxShadow: AppDesignSystem.elevation(elevation),
    );
  }

  static BoxDecoration inputDecoration(
    BuildContext context, {
    bool focused = false,
  }) {
    return BoxDecoration(
      color: surfaceContainer,
      borderRadius: BorderRadius.circular(responsiveRadius(context, 12)),
      border: Border.all(
        color: focused ? primary : border,
        width: focused ? 2 : 1,
      ),
    );
  }

  static BoxDecoration buttonDecoration(
    BuildContext context, {
    bool primary = true,
  }) {
    return BoxDecoration(
      gradient: primary ? primaryGradient : null,
      color: primary ? null : surfaceContainer,
      borderRadius: BorderRadius.circular(responsiveRadius(context, 12)),
      border: primary ? null : Border.all(color: border),
      boxShadow: primary ? elevation(2) : null,
    );
  }

  // === ANIMATION DURATIONS ===
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // === DEVICE TYPE DETECTION ===
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }
}
