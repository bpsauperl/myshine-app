import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import 'package:shine_kit/shine_kit.dart';

import '../theme.dart';

/// The "myShine" wordmark in ink, until the official logo arrives.
class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    final style = TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w600,
      letterSpacing: -size * 0.02,
      color: palette.ink,
      height: 1,
    );
    return Semantics(
      label: 'myShine',
      excludeSemantics: true,
      child: Text('myShine', style: style),
    );
  }
}

/// A light grey rounded tile (dark grey in dark mode).
class ShineCard extends StatelessWidget {
  const ShineCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(18, 16, 18, 16),
    this.radius = kCardRadius,
    this.color,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return Material(
      color: color ?? context.shine.card,
      borderRadius: BorderRadius.circular(radius),
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}

/// A small grey caption above a group of cards.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 14, 4, 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: context.shine.muted,
        ),
      ),
    );
  }
}

/// The large title of a tab, with a calm grey line under it.
class PageTitle extends StatelessWidget {
  const PageTitle(this.title, {super.key, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 10, 4, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              title,
              style: largeTitle(context),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 15,
                color: context.shine.muted,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A friendly empty or error state with an optional action.
class CalmMessage extends StatelessWidget {
  const CalmMessage({
    super.key,
    required this.icon,
    required this.title,
    this.body,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    return ShineCard(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Column(
        children: [
          KitIconBadge(icon: icon, size: 56),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (body != null) ...[
            const SizedBox(height: 8),
            Text(
              body!,
              textAlign: TextAlign.center,
              style: TextStyle(color: palette.muted, fontSize: 15, height: 1.4),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

/// 34 px bold, tight: the large title of every tab.
TextStyle largeTitle(BuildContext context) => TextStyle(
  fontSize: 34,
  fontWeight: FontWeight.w700,
  letterSpacing: -1.2,
  height: 1.1,
  color: context.shine.ink,
);

/// A grey rounded group of rows with hairlines between them, as in iOS Settings.
class ShineGroup extends StatelessWidget {
  const ShineGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    return Material(
      color: palette.card,
      borderRadius: BorderRadius.circular(kCardRadius),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Divider(height: 0.5, thickness: 0.5, color: palette.hairline),
              ),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// One row in a [ShineGroup]: a title, an optional grey line under it, and
/// something on the right (a value, an action word or a switch).
class ShineRow extends StatelessWidget {
  const ShineRow({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.trailingText,
    this.onTap,
    this.bold = false,
    this.danger = false,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final String? trailingText;
  final VoidCallback? onTap;
  final bool bold;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    final red = Theme.of(context).brightness == Brightness.dark
        ? ShineColors.darkRed
        : ShineColors.red;
    final row = Padding(
      padding: const EdgeInsets.fromLTRB(18, 13, 18, 13),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
                    color: danger ? red : palette.ink,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(fontSize: 13, color: palette.muted),
                  ),
                ],
              ],
            ),
          ),
          if (trailingText != null) ...[
            const SizedBox(width: 12),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Text(
                trailingText!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: onTap != null ? FontWeight.w600 : FontWeight.w400,
                  color: onTap != null ? palette.ink : palette.muted,
                ),
              ),
            ),
          ],
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
        ],
      ),
    );
    return onTap == null
        ? row
        : InkWell(onTap: onTap, child: Semantics(button: true, child: row));
  }
}

/// The thin line icons of myShine (24 px grid, 1.8 stroke), drawn in code.
enum ShineGlyph { today, plan, schedule, messages, profile }

class ShineIcon extends StatelessWidget {
  const ShineIcon(this.glyph, {super.key, this.size = 22, this.color});

  final ShineGlyph glyph;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(size),
        painter: _GlyphPainter(glyph, color ?? IconTheme.of(context).color ?? context.shine.ink),
      ),
    );
  }
}

class _GlyphPainter extends CustomPainter {
  _GlyphPainter(this.glyph, this.color);

  final ShineGlyph glyph;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24;
    canvas.scale(scale);
    final pen = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    switch (glyph) {
      case ShineGlyph.today:
        canvas.drawCircle(const Offset(12, 12), 4, pen);
        for (final ray in const [
          [12.0, 2.0, 12.0, 4.0], [12.0, 20.0, 12.0, 22.0], [2.0, 12.0, 4.0, 12.0], [20.0, 12.0, 22.0, 12.0],
          [4.9, 4.9, 6.3, 6.3], [17.7, 17.7, 19.1, 19.1], [4.9, 19.1, 6.3, 17.7], [17.7, 6.3, 19.1, 4.9],
        ]) {
          canvas.drawLine(Offset(ray[0], ray[1]), Offset(ray[2], ray[3]), pen);
        }
      case ShineGlyph.plan:
        canvas.drawPath(
          Path()
            ..moveTo(12, 3)
            ..lineTo(20, 7.5)
            ..lineTo(20, 16.5)
            ..lineTo(12, 21)
            ..lineTo(4, 16.5)
            ..lineTo(4, 7.5)
            ..close()
            ..moveTo(4, 7.5)
            ..lineTo(12, 12)
            ..lineTo(20, 7.5)
            ..moveTo(12, 12)
            ..lineTo(12, 21),
          pen,
        );
      case ShineGlyph.schedule:
        canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(3.5, 5, 17, 15), const Radius.circular(3)), pen);
        canvas.drawLine(const Offset(8, 3), const Offset(8, 7), pen);
        canvas.drawLine(const Offset(16, 3), const Offset(16, 7), pen);
        canvas.drawLine(const Offset(3.5, 10), const Offset(20.5, 10), pen);
      case ShineGlyph.messages:
        canvas.drawPath(
          Path()
            ..moveTo(4, 6)
            ..arcToPoint(const Offset(6, 4), radius: const Radius.circular(2))
            ..lineTo(18, 4)
            ..arcToPoint(const Offset(20, 6), radius: const Radius.circular(2))
            ..lineTo(20, 15)
            ..arcToPoint(const Offset(18, 17), radius: const Radius.circular(2))
            ..lineTo(9, 17)
            ..lineTo(4, 21)
            ..close(),
          pen,
        );
      case ShineGlyph.profile:
        canvas.drawCircle(const Offset(12, 8), 4, pen);
        canvas.drawArc(const Rect.fromLTWH(4, 13, 16, 16), 3.14159, 3.14159, false, pen);
    }
  }

  @override
  bool shouldRepaint(_GlyphPainter old) => old.glyph != glyph || old.color != color;
}

/// One place in the glass tab bar.
class GlassTab {
  const GlassTab({required this.glyph, required this.label, this.dot = false});

  final ShineGlyph glyph;
  final String label;
  final bool dot;
}

/// The floating glass tab bar: white at 72 % over a blur of the page, a hairline
/// edge and a soft shadow; the chosen tab sits on a light grey pill.
class GlassTabBar extends StatelessWidget {
  const GlassTabBar({
    super.key,
    required this.tabs,
    required this.index,
    required this.onSelect,
  });

  final List<GlassTab> tabs;
  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final palette = context.shine;
    final idle = dark ? const Color(0xFF8E8E93) : const Color(0xFF8E8E93);
    return Container(
      height: 66,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(33),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.5 : 0.10),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(33),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: (dark ? const Color(0xFF1C1C1E) : Colors.white).withValues(alpha: dark ? 0.72 : 0.72),
              borderRadius: BorderRadius.circular(33),
              border: Border.all(
                color: (dark ? Colors.white : Colors.black).withValues(alpha: 0.08),
                width: 0.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  for (var i = 0; i < tabs.length; i++)
                    Expanded(
                      child: Semantics(
                        button: true,
                        selected: i == index,
                        label: tabs[i].dot ? '${tabs[i].label}, new' : tabs[i].label,
                        excludeSemantics: true,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onSelect(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutCubic,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            decoration: BoxDecoration(
                              color: i == index
                                  ? (dark ? Colors.white : Colors.black).withValues(alpha: dark ? 0.12 : 0.06)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    ShineIcon(tabs[i].glyph, color: i == index ? palette.ink : idle),
                                    if (tabs[i].dot)
                                      Positioned(
                                        right: -3,
                                        top: -1,
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: dark ? ShineColors.darkRed : ShineColors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  tabs[i].label.split(',').first,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: i == index ? FontWeight.w600 : FontWeight.w500,
                                    color: i == index ? palette.ink : idle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
