import 'package:flutter/material.dart';

/// The patient-facing Shine palette: white and light grey, near-black ink and
/// one accent, Shine teal.
class ShineColors {
  ShineColors._();

  static const Color teal = Color(0xFF83C9CB);
  static const Color tealText = Color(0xFF12787C);
  static const Color tealSoft = Color(0xFFE8F5F5);
  static const Color ink = Color(0xFF1D1D1F);
  static const Color grey = Color(0xFFF5F5F7);
  static const Color muted = Color(0xFF6E6E73);

  static const Color darkBackground = Color(0xFF000000);
  static const Color darkCard = Color(0xFF1C1C1E);
  static const Color darkSoft = Color(0xFF15302F);
  static const Color darkTealText = Color(0xFF83C9CB);
}

/// Colours that change between light and dark mode, read with `context.shine`.
@immutable
class ShinePalette extends ThemeExtension<ShinePalette> {
  const ShinePalette({
    required this.background,
    required this.card,
    required this.ink,
    required this.muted,
    required this.accentText,
    required this.accentSoft,
    required this.hairline,
  });

  final Color background;
  final Color card;
  final Color ink;
  final Color muted;
  final Color accentText;
  final Color accentSoft;
  final Color hairline;

  static const ShinePalette light = ShinePalette(
    background: ShineColors.grey,
    card: Colors.white,
    ink: ShineColors.ink,
    muted: ShineColors.muted,
    accentText: ShineColors.tealText,
    accentSoft: ShineColors.tealSoft,
    hairline: Color(0xFFE5E5EA),
  );

  static const ShinePalette dark = ShinePalette(
    background: ShineColors.darkBackground,
    card: ShineColors.darkCard,
    ink: Color(0xFFF5F5F7),
    muted: Color(0xFF98989D),
    accentText: ShineColors.darkTealText,
    accentSoft: ShineColors.darkSoft,
    hairline: Color(0xFF38383A),
  );

  @override
  ShinePalette copyWith({
    Color? background,
    Color? card,
    Color? ink,
    Color? muted,
    Color? accentText,
    Color? accentSoft,
    Color? hairline,
  }) {
    return ShinePalette(
      background: background ?? this.background,
      card: card ?? this.card,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      accentText: accentText ?? this.accentText,
      accentSoft: accentSoft ?? this.accentSoft,
      hairline: hairline ?? this.hairline,
    );
  }

  @override
  ShinePalette lerp(ShinePalette? other, double t) {
    if (other == null) {
      return this;
    }
    return ShinePalette(
      background: Color.lerp(background, other.background, t)!,
      card: Color.lerp(card, other.card, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      accentText: Color.lerp(accentText, other.accentText, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
    );
  }
}

extension ShineContext on BuildContext {
  ShinePalette get shine =>
      Theme.of(this).extension<ShinePalette>() ?? ShinePalette.light;
}

/// Card corner radius used everywhere.
const double kCardRadius = 22;

ThemeData buildShineTheme(Brightness brightness) {
  final palette = brightness == Brightness.dark
      ? ShinePalette.dark
      : ShinePalette.light;
  final scheme =
      ColorScheme.fromSeed(
        seedColor: ShineColors.teal,
        brightness: brightness,
      ).copyWith(
        primary: palette.accentText,
        onPrimary: brightness == Brightness.dark
            ? ShineColors.ink
            : Colors.white,
        secondary: ShineColors.teal,
        surface: palette.card,
        onSurface: palette.ink,
      );

  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: palette.background,
    extensions: [palette],
  );

  final text = base.textTheme.apply(
    bodyColor: palette.ink,
    displayColor: palette.ink,
  );

  return base.copyWith(
    textTheme: text.copyWith(
      displaySmall: text.displaySmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -1.2,
        height: 1.08,
      ),
      headlineMedium: text.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
      ),
      titleLarge: text.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: palette.background,
      foregroundColor: palette.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: text.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
    ),
    cardTheme: CardThemeData(
      color: palette.card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: palette.ink,
        foregroundColor: palette.card,
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: palette.ink,
        minimumSize: const Size.fromHeight(54),
        side: BorderSide(color: palette.hairline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: palette.accentText),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: palette.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: ShineColors.teal, width: 2),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: palette.background,
      selectedColor: palette.accentSoft,
      side: BorderSide.none,
      shape: const StadiumBorder(),
      labelStyle: TextStyle(color: palette.ink, fontWeight: FontWeight.w500),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: palette.card,
      indicatorColor: palette.accentSoft,
      elevation: 0,
      height: 68,
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(
          fontSize: 11,
          color: palette.ink,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    dividerTheme: DividerThemeData(color: palette.hairline, space: 1),
  );
}
