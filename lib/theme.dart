import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

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

/// The app theme comes from the shared Shine kit (Direction C), in Shine
/// teal, with this app's own palette alongside for the screens that read it.
ThemeData buildShineTheme(Brightness brightness) {
  final kit = kitTheme(KitAccent.myShine, brightness);
  final palette = brightness == Brightness.dark ? ShinePalette.dark : ShinePalette.light;
  return kit.copyWith(extensions: [...kit.extensions.values, palette]);
}
