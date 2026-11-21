import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

/// myShine's palette: white page, light grey tiles, near-black ink and black
/// buttons. No colour accent: the black pill button is the one strong thing.
class ShineColors {
  ShineColors._();

  static const Color ink = Color(0xFF1D1D1F);
  static const Color grey = Color(0xFFF5F5F7);
  static const Color muted = Color(0xFF6E6E73);
  static const Color tertiary = Color(0xFF86868B);
  static const Color hairline = Color(0xFFE5E5EA);
  static const Color soft = Color(0xFFE8E8ED);
  static const Color red = Color(0xFFD70015);

  /// Shine teal: only for the brand pictures (app icon, store art) until the
  /// official myShine logo replaces them. Not used on screens.
  static const Color teal = Color(0xFF83C9CB);
  static const Color tealText = Color(0xFF12787C);

  static const Color darkBackground = Color(0xFF000000);
  static const Color darkCard = Color(0xFF1C1C1E);
  static const Color darkInset = Color(0xFF2C2C2E);
  static const Color darkInk = Color(0xFFF5F5F7);
  static const Color darkRed = Color(0xFFFF6961);
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
    background: Colors.white,
    card: ShineColors.grey,
    ink: ShineColors.ink,
    muted: ShineColors.muted,
    accentText: ShineColors.ink,
    accentSoft: ShineColors.soft,
    hairline: ShineColors.hairline,
  );

  static const ShinePalette dark = ShinePalette(
    background: ShineColors.darkBackground,
    card: ShineColors.darkCard,
    ink: ShineColors.darkInk,
    muted: Color(0xFF98989D),
    accentText: ShineColors.darkInk,
    accentSoft: ShineColors.darkInset,
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

/// The big tile on Today.
const double kHeroRadius = 28;

/// myShine in black and white: the shared kit's look (type, pills, sizes) with
/// a white page, grey tiles and ink where the kit would use a colour accent.
const KitAccent _mono = KitAccent(
  name: 'myShine',
  accent: ShineColors.ink,
  accentText: ShineColors.ink,
  accentSoft: ShineColors.soft,
  ground: Colors.white,
  accentDark: ShineColors.darkInk,
  accentSoftDark: ShineColors.darkInset,
);

KitPalette _kitPalette(bool dark) => dark
    ? const KitPalette(
        isDark: true,
        ground: ShineColors.darkBackground,
        tile: ShineColors.darkCard,
        inset: ShineColors.darkInset,
        ink: ShineColors.darkInk,
        secondary: Color(0xFFA1A1A6),
        tertiary: Color(0xFF8E8E93),
        hairline: Color(0xFF38383A),
        accent: ShineColors.darkInk,
        accentText: ShineColors.darkInk,
        accentSoft: ShineColors.darkInset,
        halo: ShineColors.darkCard,
        danger: ShineColors.darkRed,
      )
    : const KitPalette(
        isDark: false,
        ground: Colors.white,
        tile: ShineColors.grey,
        inset: Colors.white,
        ink: ShineColors.ink,
        secondary: ShineColors.muted,
        tertiary: ShineColors.tertiary,
        hairline: ShineColors.hairline,
        accent: ShineColors.ink,
        accentText: ShineColors.ink,
        accentSoft: ShineColors.soft,
        halo: Colors.white,
        danger: ShineColors.red,
      );

ThemeData buildShineTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final kit = kitTheme(_mono, brightness);
  final k = _kitPalette(dark);
  final palette = dark ? ShinePalette.dark : ShinePalette.light;
  final onInk = dark ? Colors.black : Colors.white;
  final field = OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: BorderSide.none,
  );
  return kit.copyWith(
    scaffoldBackgroundColor: k.ground,
    colorScheme: kit.colorScheme.copyWith(
      primary: k.ink,
      onPrimary: onInk,
      primaryContainer: k.tile,
      onPrimaryContainer: k.ink,
      secondary: k.ink,
      surface: k.ground,
      surfaceContainerLow: k.tile,
      surfaceContainer: k.tile,
      surfaceContainerHigh: k.tile,
      error: k.danger,
    ),
    appBarTheme: kit.appBarTheme.copyWith(backgroundColor: k.ground),
    cardTheme: kit.cardTheme.copyWith(
      color: k.tile,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
    ),
    dividerTheme: DividerThemeData(color: k.hairline, thickness: 0.5, space: 0.5),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: k.ink,
        minimumSize: const Size(KitSize.touch, KitSize.touch),
        textStyle: const TextStyle(fontFamily: KitType.text, fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: -0.1),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: k.ink,
        backgroundColor: k.tile,
        minimumSize: const Size.fromHeight(KitSize.buttonHeight),
        side: BorderSide.none,
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontFamily: KitType.text, fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: -0.1),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: k.ink,
        foregroundColor: onInk,
        disabledBackgroundColor: k.hairline,
        disabledForegroundColor: k.secondary,
        minimumSize: const Size.fromHeight(KitSize.buttonHeight),
        shape: const StadiumBorder(),
        elevation: 0,
        textStyle: const TextStyle(fontFamily: KitType.text, fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: -0.1),
      ),
    ),
    inputDecorationTheme: kit.inputDecorationTheme.copyWith(
      fillColor: k.tile,
      border: field,
      enabledBorder: field,
      focusedBorder: field.copyWith(borderSide: BorderSide(color: k.ink, width: 1.5)),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(dark ? Colors.black : Colors.white),
      trackColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? k.ink : k.hairline),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: k.ink),
    extensions: [k, palette],
  );
}
