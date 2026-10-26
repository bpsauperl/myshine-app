import 'package:flutter/material.dart';

import '../theme.dart';

/// "myShine", with "my" in Shine teal.
class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    final style = TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w700,
      letterSpacing: -size * 0.03,
      color: palette.ink,
      height: 1,
    );
    return Semantics(
      label: 'myShine',
      excludeSemantics: true,
      child: Text.rich(
        TextSpan(
          style: style,
          children: [
            TextSpan(
              text: 'my',
              style: TextStyle(color: palette.accentText),
            ),
            const TextSpan(text: 'Shine'),
          ],
        ),
      ),
    );
  }
}

/// A rounded white (or dark grey) card.
class ShineCard extends StatelessWidget {
  const ShineCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return Material(
      color: color ?? context.shine.card,
      borderRadius: BorderRadius.circular(kCardRadius),
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
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          letterSpacing: 0.6,
          fontWeight: FontWeight.w600,
          color: context.shine.muted,
        ),
      ),
    );
  }
}

/// A big headline with a calm grey line under it.
class PageTitle extends StatelessWidget {
  const PageTitle(this.title, {super.key, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 16,
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
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: palette.accentSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: palette.accentText, size: 28),
          ),
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
