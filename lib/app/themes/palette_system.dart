import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design system palette for School App (Blue Theme)
/// Author: Cheikh Tidiane
/// Last updated: July 11, 2025

class AppDesignSystem {
  // === POINTS DE RUPTURE ===
  /// Largeur max. pour l’affichage mobile.
  static const double mobileBreakpoint = 600;

  /// Largeur max. pour l’affichage tablette.
  static const double tabletBreakpoint = 900;

  /// À partir de cette largeur l’affichage est considéré desktop.
  static const double desktopBreakpoint = 1200;

  // === PALETTE DE COULEURS ===
  // Couleurs primaires (bleu académique)
  /// Bleu marine riche pour les surfaces sombres.
  static const Color primaryDark = Color(0xFF0F172A);
  static const Color cardDark = Color(0xFF1F2937);

  /// Bleu institutionnel principal.
  static const Color primary = Color(0xFF1E40AF);

  /// Bleu lumineux pour les états survol / actif.
  static const Color primaryLight = Color(0xFF3B82F6);

  /// Teinte bleu clair pour les arrière-plans doux.
  static const Color primarySoft = Color(0xFFDBEAFE);

  // Couleurs secondaires et d’accent
  static const Color secondary = Color(0xFF7C3AED); // Violet académique
  static const Color secondaryLight = Color(0xFFA855F7); // Violet clair
  static const Color accent = Color(0xFFEAB308); // Or
  static const Color accentLight = Color(0xFFFEF3C7); // Or clair

  // États (succès / avertissement / erreur / information)
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Neutres — gris professionnels
  static const Color surfaceDark = Color(0xFF111827);
  static const Color surface = Color(0xFFFAFAFA);
  static const Color surfaceContainer = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textInverse = Color(0xFFFFFFFF);

  static const Color border = Color(0xFFE2E8F0);
  static const Color borderVariant = Color(0xFFCBD5E1);
  static const Color divider = Color(0xFFF1F5F9);

  // === DÉGRADÉS ===
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

  // === ESPACEMENT & DIMENSIONS RÉACTIVES ===
  /// Calcule un espacement proportionnel à la largeur d’écran.
  static double spacing(BuildContext context, double base) =>
      base * _scale(context);

  static double _scale(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < mobileBreakpoint) return 0.9;
    if (w < tabletBreakpoint) return 1.0;
    if (w < desktopBreakpoint) return 1.1;
    return 1.2;
  }

  static double responsiveRadius(BuildContext c, double base) =>
      base * _scale(c);
  static double responsiveSize(BuildContext c, double base) => base * _scale(c);

  /// Renv. un padding symétrique ou uniforme adapté à l’écran.
  static EdgeInsets responsivePadding(
    BuildContext c, {
    double horizontal = 16,
    double vertical = 16,
    double? all,
  }) {
    final s = _scale(c);
    return all != null
        ? EdgeInsets.all(all * s)
        : EdgeInsets.symmetric(
            horizontal: horizontal * s,
            vertical: vertical * s,
          );
  }

  // === TYPOGRAPHIE ===
  /// Définit la hiérarchie de texte Inter ; tailles ajustées à l’écran.
  static TextTheme textTheme(BuildContext c) {
    final s = _scale(c);
    return GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 34 * s,
        fontWeight: FontWeight.w800,
        color: textPrimary,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 30 * s,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.3,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 26 * s,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.3,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 24 * s,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 20 * s,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 18 * s,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 18 * s,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.5,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16 * s,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.5,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14 * s,
        fontWeight: FontWeight.w600,
        color: textSecondary,
        height: 1.5,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 18 * s,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 16 * s,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.6,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 14 * s,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.6,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 16 * s,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        height: 1.4,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 14 * s,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        height: 1.4,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 12 * s,
        fontWeight: FontWeight.w500,
        color: textTertiary,
        height: 1.4,
      ),
    );
  }

  // === OMBRES ===
  /// Génère une élévation (1–4) sous forme de liste de [BoxShadow].
  static List<BoxShadow> elevation(int level) {
    switch (level) {
      case 1:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ];
      case 2:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ];
      case 3:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ];
      case 4:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            offset: const Offset(0, 6),
            blurRadius: 18,
          ),
        ];
      default:
        return [];
    }
  }

  // === STYLES DE COMPOSANT ===
  /// Décoration d’une carte avec rayon réactif et élévation.
  static BoxDecoration cardDecoration(BuildContext c, {int elevation = 2}) =>
      BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(responsiveRadius(c, 16)),
        boxShadow: AppDesignSystem.elevation(elevation),
      );

  /// Décoration d’un champ de saisie ; change de bordure selon le focus.
  static BoxDecoration inputDecoration(
    BuildContext c, {
    bool focused = false,
  }) => BoxDecoration(
    color: surfaceContainer,
    borderRadius: BorderRadius.circular(responsiveRadius(c, 12)),
    border: Border.all(
      color: focused ? primary : border,
      width: focused ? 2 : 1,
    ),
  );

  /// Décoration d’un bouton (plein ou secondaire).
  static BoxDecoration buttonDecoration(
    BuildContext c, {
    bool primary = true,
  }) => BoxDecoration(
    gradient: primary ? primaryGradient : null,
    color: primary ? null : surfaceContainer,
    borderRadius: BorderRadius.circular(responsiveRadius(c, 12)),
    border: primary ? null : Border.all(color: border),
    boxShadow: primary ? elevation(2) : null,
  );

  // === DURÉES D’ANIMATION ===
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // === DÉTECTION DE TYPE D’APPAREIL ===
  static bool isMobile(BuildContext c) =>
      MediaQuery.of(c).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    return w >= mobileBreakpoint && w < desktopBreakpoint;
  }

  static bool isDesktop(BuildContext c) =>
      MediaQuery.of(c).size.width >= desktopBreakpoint;

  /// Returns the primary color based on the current theme (light/dark).
  static Color primaryOf(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? primaryLight : primary;
  }

  /// Returns the background color based on the current theme (light/dark).
  static Color backgroundOf(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? surfaceDark : surface;
  }

  /// Returns the surface color based on the current theme (light/dark).
  static Color surfaceOf(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? surfaceDark : surface;
  }

  /// Returns the text primary color based on the current theme (light/dark).
  static Color textPrimaryOf(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? textInverse : textPrimary;
  }

  /// Returns the text secondary color based on the current theme (light/dark).
  static Color textSecondaryOf(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? textTertiary : textSecondary;
  }

  static Color textFieldOf(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? Colors.black : Colors.black;
  }

  /// Returns the card color based on the current theme (light/dark).
  static Color cardOf(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? cardDark : surfaceContainer;
  }
}

/// Thème clair basé sur [AppDesignSystem].
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppDesignSystem.primary,
  scaffoldBackgroundColor: AppDesignSystem.surface,
  textTheme: GoogleFonts.interTextTheme(),
  appBarTheme: AppBarTheme(
    backgroundColor: AppDesignSystem.surface,
    foregroundColor: AppDesignSystem.textPrimary,
    elevation: 1,
  ),
  colorScheme: ColorScheme.light(
    primary: AppDesignSystem.primary,
    secondary: AppDesignSystem.secondary,
    surface: AppDesignSystem.surface,
    background: AppDesignSystem.surfaceContainer,
    error: AppDesignSystem.error,
    onPrimary: AppDesignSystem.textInverse,
    onSecondary: AppDesignSystem.textInverse,
    onSurface: AppDesignSystem.textPrimary,
    onBackground: AppDesignSystem.textPrimary,
    onError: AppDesignSystem.textInverse,
  ),
);

/// Thème sombre basé sur [AppDesignSystem].
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppDesignSystem.primaryLight,
  scaffoldBackgroundColor: AppDesignSystem.surfaceDark,
  textTheme: GoogleFonts.interTextTheme(),
  appBarTheme: AppBarTheme(
    backgroundColor: AppDesignSystem.surfaceDark,
    foregroundColor: AppDesignSystem.textInverse,
    elevation: 1,
  ),
  colorScheme: ColorScheme.dark(
    primary: AppDesignSystem.primaryLight,
    secondary: AppDesignSystem.secondaryLight,
    surface: AppDesignSystem.surfaceDark,
    background: AppDesignSystem.surfaceDark,
    error: AppDesignSystem.error,
    onPrimary: AppDesignSystem.textInverse,
    onSecondary: AppDesignSystem.textInverse,
    onSurface: AppDesignSystem.textInverse,
    onBackground: AppDesignSystem.textInverse,
    onError: AppDesignSystem.textInverse,
  ),
);
