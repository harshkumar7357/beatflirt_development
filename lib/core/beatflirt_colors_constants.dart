import 'package:flutter/material.dart';

/// ╔══════════════════════════════════════════════════════════════════╗
/// ║           BEAT FLIRT — Official Color System                    ║
/// ║           Extracted from beatflirtevent.com                     ║
/// ╚══════════════════════════════════════════════════════════════════╝

class BeatFlirtColors {
  BeatFlirtColors._(); // prevent instantiation

  // ─────────────────────────────────────────────────────────────────
  // 🎨 PRIMARY BRAND COLORS (from CSS :root variables)
  // ─────────────────────────────────────────────────────────────────

  /// Primary Blue — Main brand color used on buttons, links, accents
  static const Color primary = Color(0xFF01529C);

  /// Secondary Deep Blue/Indigo — Used for gradients and highlights
  static const Color secondary = Color(0xFF1C1AA1);

  // ─────────────────────────────────────────────────────────────────
  // 🌈 GRADIENTS
  // ─────────────────────────────────────────────────────────────────

  /// Primary Brand Gradient (Blue → Indigo) — Used on main CTAs & buttons
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF01529C), Color(0xFF1C1AA1)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Primary Gradient (Diagonal) — For cards & hero sections
  static const LinearGradient primaryGradientDiagonal = LinearGradient(
    colors: [Color(0xFF01529C), Color(0xFF1C1AA1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Hero Dark Overlay Gradient — Used on hero/slider backgrounds
  static const LinearGradient heroOverlayGradient = LinearGradient(
    colors: [Color(0xFF2E2200), Color(0xFF000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Dark Navy Gradient — Used on dark section backgrounds
  static const LinearGradient darkSectionGradient = LinearGradient(
    colors: [Color(0xFF0A1628), Color(0xFF0D0D1A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Blue Highlight Gradient — Used on feature/info sections
  static const LinearGradient blueHighlightGradient = LinearGradient(
    colors: [Color(0xFF1696E7), Color(0xFF01529C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// White to Transparent — Nav bar fade effect
  static const LinearGradient navFadeGradient = LinearGradient(
    colors: [Colors.white, Colors.transparent],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ─────────────────────────────────────────────────────────────────
  // 🖤 BACKGROUND COLORS
  // ─────────────────────────────────────────────────────────────────

  /// Main page background (white)
  static const Color backgroundWhite = Color(0xFFFFFFFF);

  /// Light gray background — Used for alternate sections
  static const Color backgroundGray = Color(0xFFF7F7FD);

  /// Slightly warmer gray — Used for brand sections
  static const Color backgroundBrand = Color(0xFFF1F4FA);

  /// Testimonials background
  static const Color backgroundTestimonial = Color(0xFFF9FAFC);

  /// Pure black — Dark overlays
  static const Color backgroundBlack = Color(0xFF000000);

  /// Deep dark navy — Dark mode background
  static const Color backgroundDark = Color(0xFF0D0D1A);

  /// Dark overlay brown (with opacity 0.5) — Hero/slider overlays
  static const Color overlayBrown = Color(0xFF2E2200);

  // ─────────────────────────────────────────────────────────────────
  // ✍️ TEXT COLORS
  // ─────────────────────────────────────────────────────────────────

  /// Heading color (light mode)
  static const Color headingLight = Color(0xFFF2F2F2);

  /// Body text / paragraph color
  static const Color bodyText = Color(0xFF333333);

  /// Muted / secondary text
  static const Color mutedText = Color(0xFF888888);

  /// Link / anchor text color
  static const Color linkText = Color(0xFF635C5C);

  /// White text — On dark/colored backgrounds
  static const Color textWhite = Color(0xFFFFFFFF);

  /// Black text
  static const Color textBlack = Color(0xFF000000);

  // ─────────────────────────────────────────────────────────────────
  // 🔘 BUTTON COLORS
  // ─────────────────────────────────────────────────────────────────

  /// Primary button background
  static const Color buttonPrimary = Color(0xFF01529C);

  /// Header button background
  static const Color buttonHeader = Color(0xFF195281);

  /// Header button hover
  static const Color buttonHeaderHover = Color(0xFF7FB9EE);

  /// Submit / CTA button (Red-orange)
  static const Color buttonSubmit = Color(0xFFEC5B53);

  /// Dark/Black button
  static const Color buttonBlack = Color(0xFF000000);

  /// White button background
  static const Color buttonWhite = Color(0xFFFFFFFF);

  /// White button text color
  static const Color buttonWhiteText = Color(0xFF331391);

  // ─────────────────────────────────────────────────────────────────
  // 🌟 ACCENT / HIGHLIGHT COLORS
  // ─────────────────────────────────────────────────────────────────

  /// Sky Blue — Overlay/highlight accent
  static const Color accentSkyBlue = Color(0xFF1696E7);

  /// Royal Purple — Used in white button text & dark button hover
  static const Color accentPurple = Color(0xFF331391);

  /// Coral Red — Scroll up button, owl carousel hover
  static const Color accentCoral = Color(0xFFFF3500);

  /// Light Blue — Interactive highlights
  static const Color accentLightBlue = Color(0xFF7FB9EE);

  // ─────────────────────────────────────────────────────────────────
  // 🔲 BORDER & DIVIDER COLORS
  // ─────────────────────────────────────────────────────────────────

  /// Default border/divider
  static const Color borderDefault = Color(0xFFECEFF8);

  /// Horizontal rule color
  static const Color divider = Color(0xFFF2F2F2);

  /// Box shadow color (semi-transparent)
  static const Color shadowColor = Color(0x336C6262);

  // ─────────────────────────────────────────────────────────────────
  // 🎨 FULL PALETTE — Quick Reference List
  // ─────────────────────────────────────────────────────────────────

  static const List<_BFColorEntry> palette = [
    _BFColorEntry('Primary Blue',       Color(0xFF01529C), 'Main brand color — buttons, links, accents'),
    _BFColorEntry('Secondary Indigo',   Color(0xFF1C1AA1), 'Gradient partner to primary'),
    _BFColorEntry('Sky Blue Accent',    Color(0xFF1696E7), 'Highlight overlay & feature accents'),
    _BFColorEntry('Light Blue Hover',   Color(0xFF7FB9EE), 'Button hover state'),
    _BFColorEntry('Royal Purple',       Color(0xFF331391), 'White button text & dark hover bg'),
    _BFColorEntry('Header Button Bg',   Color(0xFF195281), 'Nav header button'),
    _BFColorEntry('Submit Red',         Color(0xFFEC5B53), 'CTA / form submit button'),
    _BFColorEntry('Coral Hover',        Color(0xFFFF3500), 'Carousel hover, scroll button'),
    _BFColorEntry('Dark Overlay',       Color(0xFF2E2200), 'Hero/slider dark overlay'),
    _BFColorEntry('White',              Color(0xFFFFFFFF), 'Text, backgrounds, buttons'),
    _BFColorEntry('Light Gray Bg',      Color(0xFFF7F7FD), 'Alternate section background'),
    _BFColorEntry('Brand Bg',           Color(0xFFF1F4FA), 'Brand/feature section background'),
    _BFColorEntry('Testimonial Bg',     Color(0xFFF9FAFC), 'Testimonial section background'),
    _BFColorEntry('Heading Light',      Color(0xFFF2F2F2), 'H1–H6 heading color'),
    _BFColorEntry('Link Gray',          Color(0xFF635C5C), 'Default anchor/link color'),
    _BFColorEntry('Muted Text',         Color(0xFF888888), 'Breadcrumb / secondary text'),
    _BFColorEntry('Border',             Color(0xFFECEFF8), 'Dividers and card borders'),
    _BFColorEntry('Pure Black',         Color(0xFF000000), 'Dark backgrounds & text'),
    _BFColorEntry('Dark Navy',          Color(0xFF0D0D1A), 'Dark mode page background'),
  ];
}

// ─────────────────────────────────────────────────────────────────
// 🛠 Helper class for the palette list
// ─────────────────────────────────────────────────────────────────
class _BFColorEntry {
  final String name;
  final Color color;
  final String usage;
  const _BFColorEntry(this.name, this.color, this.usage);
}

// ─────────────────────────────────────────────────────────────────
// 🎨 GRADIENTS — Ready-to-use gradient definitions
// ─────────────────────────────────────────────────────────────────

class BeatFlirtGradients {
  BeatFlirtGradients._();

  /// 🔵 Primary: Blue → Indigo (horizontal) — Main CTA, buttons
  static const LinearGradient primary = LinearGradient(
    colors: [Color(0xFF01529C), Color(0xFF1C1AA1)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// 🔵 Primary Diagonal — Cards, containers
  static const LinearGradient primaryDiagonal = LinearGradient(
    colors: [Color(0xFF01529C), Color(0xFF1C1AA1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 🔵 Primary Vertical — Section headers
  static const LinearGradient primaryVertical = LinearGradient(
    colors: [Color(0xFF01529C), Color(0xFF1C1AA1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// 🌊 Blue Highlight — Feature highlights, banners
  static const LinearGradient blueHighlight = LinearGradient(
    colors: [Color(0xFF1696E7), Color(0xFF01529C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 🌑 Hero Dark — Full-bleed hero/slider overlays
  static const LinearGradient heroDark = LinearGradient(
    colors: [Color(0xCC2E2200), Color(0xCC000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// 🌑 Dark Section — Dark-mode section backgrounds
  static const LinearGradient darkSection = LinearGradient(
    colors: [Color(0xFF0A1628), Color(0xFF0D0D1A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 🔴 Danger/Submit — Form submit, alert actions
  static const LinearGradient danger = LinearGradient(
    colors: [Color(0xFFEC5B53), Color(0xFFFF3500)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// 🟣 Purple Accent — Special highlights
  static const LinearGradient purple = LinearGradient(
    colors: [Color(0xFF331391), Color(0xFF1C1AA1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ─────────────────────────────────────────────────────────────────
// 🖌 THEME DATA — Drop-in Flutter ThemeData using Beat Flirt colors
// ─────────────────────────────────────────────────────────────────

class BeatFlirtTheme {
  BeatFlirtTheme._();

  /// ☀️ Light Theme (matches website)
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: BeatFlirtColors.backgroundWhite,
        colorScheme: const ColorScheme.light(
          primary: BeatFlirtColors.primary,
          secondary: BeatFlirtColors.secondary,
          surface: BeatFlirtColors.backgroundGray,
          error: BeatFlirtColors.buttonSubmit,
          onPrimary: BeatFlirtColors.textWhite,
          onSecondary: BeatFlirtColors.textWhite,
          onSurface: BeatFlirtColors.bodyText,
          onError: BeatFlirtColors.textWhite,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: BeatFlirtColors.backgroundWhite,
          foregroundColor: BeatFlirtColors.primary,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: BeatFlirtColors.primary,
            foregroundColor: BeatFlirtColors.textWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: BeatFlirtColors.primary,
            side: const BorderSide(color: BeatFlirtColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: BeatFlirtColors.primary,
          ),
        ),
        dividerColor: BeatFlirtColors.borderDefault,
        cardTheme: CardThemeData(
          color: BeatFlirtColors.backgroundWhite,
          elevation: 4,
          shadowColor: BeatFlirtColors.shadowColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: BeatFlirtColors.borderDefault),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(
                color: BeatFlirtColors.primary, width: 2),
          ),
          filled: true,
          fillColor: BeatFlirtColors.backgroundGray,
        ),
        fontFamily: 'Poppins',
      );

  /// 🌙 Dark Theme (nightlife / club mode)
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: BeatFlirtColors.backgroundDark,
        colorScheme: const ColorScheme.dark(
          primary: BeatFlirtColors.accentSkyBlue,
          secondary: BeatFlirtColors.primary,
          surface: Color(0xFF0A1628),
          error: BeatFlirtColors.buttonSubmit,
          onPrimary: BeatFlirtColors.textWhite,
          onSecondary: BeatFlirtColors.textWhite,
          onSurface: BeatFlirtColors.headingLight,
          onError: BeatFlirtColors.textWhite,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A1628),
          foregroundColor: BeatFlirtColors.textWhite,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: BeatFlirtColors.primary,
            foregroundColor: BeatFlirtColors.textWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          ),
        ),
        dividerColor: const Color(0xFF1E2A3A),
        cardTheme: CardThemeData(
          color: const Color(0xFF0A1628),
          elevation: 4,
          shadowColor: Colors.black45,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFF1E2A3A)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(
                color: BeatFlirtColors.accentSkyBlue, width: 2),
          ),
          filled: true,
          fillColor: const Color(0xFF0A1628),
          hintStyle: TextStyle(color: BeatFlirtColors.mutedText),
        ),
        fontFamily: 'Poppins',
      );
}
