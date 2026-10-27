import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

import '../../config.dart';
import '../../l10n/l10n.dart';
import '../../theme.dart';
import '../../widgets/browser.dart';
import '../connect_screen.dart';
import 'smile_guide_painter.dart';

/// Brightens and whitens a little: lifts blue more than red and green, so a
/// yellow tint softens, and adds a touch of brightness.
const List<double> kWhiteningMatrix = [
  1.03, 0.03, 0.03, 0, 6, //
  0.03, 1.03, 0.03, 0, 6, //
  0.06, 0.06, 1.08, 0, 14, //
  0, 0, 0, 1, 0, //
];

/// "Your preview": the photo with a gentle illustrative effect inside the lips
/// box, and a before/after slider. Made on the device only.
class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key, required this.photo, this.isSample = false});

  /// The photo (or the sample illustration), filling its box.
  final Widget photo;
  final bool isSample;

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: palette.card,
      appBar: AppBar(
        backgroundColor: palette.card,
        title: Text(l10n.previewTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isSample)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        l10n.previewSampleNote,
                        style: TextStyle(color: palette.muted),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  BeforeAfterPreview(photo: photo),
                  const SizedBox(height: 16),
                  ShineHonestLabel(color: palette.muted),
                  const SizedBox(height: 28),
                  Text(
                    l10n.previewLikeTitle,
                    style: KitType.title(color: context.kit.ink),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.previewLikeBody,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: palette.muted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () =>
                        openInBrowserView(context, AppConfig.clinicFinderUrl),
                    child: Text(l10n.previewFindClinic),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      isSample ? l10n.commonBack : l10n.previewTakeAnother,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ConnectScreen(),
                      ),
                    ),
                    child: Text(l10n.previewHaveCode),
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

/// The honest line under every preview.
class ShineHonestLabel extends StatelessWidget {
  const ShineHonestLabel({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.previewHonest,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14, height: 1.4, color: color),
    );
  }
}

/// The photo with the effect on the left of a draggable divider ("After") and
/// the untouched photo on the right ("Before").
class BeforeAfterPreview extends StatefulWidget {
  const BeforeAfterPreview({
    super.key,
    required this.photo,
    this.initialSplit = 0.5,
  });

  final Widget photo;
  final double initialSplit;

  @override
  State<BeforeAfterPreview> createState() => _BeforeAfterPreviewState();
}

class _BeforeAfterPreviewState extends State<BeforeAfterPreview> {
  late double _split = widget.initialSplit;

  void _moveTo(double dx, double width) {
    setState(() => _split = (dx / width).clamp(0.0, 1.0));
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: SmileGuidePainter.frameAspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kCardRadius),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.biggest;
            final lips = SmileGuidePainter.lipsBoxIn(size);
            final x = size.width * _split;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragUpdate: (d) =>
                  _moveTo(d.localPosition.dx, size.width),
              onTapDown: (d) => _moveTo(d.localPosition.dx, size.width),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  widget.photo,
                  ClipRect(
                    clipper: _LeftOf(x),
                    child: SmileEffect(lipsBox: lips, child: widget.photo),
                  ),
                  Positioned(
                    left: x - 1,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 2, color: Colors.white),
                  ),
                  Positioned(
                    left: x - 20,
                    top: size.height / 2 - 20,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.unfold_more,
                        color: ShineColors.ink,
                        size: 22,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: _Tag(context.l10n.previewAfter),
                  ),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: _Tag(context.l10n.previewBefore),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LeftOf extends CustomClipper<Rect> {
  _LeftOf(this.x);

  final double x;

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, x, size.height);

  @override
  bool shouldReclip(_LeftOf oldClipper) => oldClipper.x != x;
}

class _Tag extends StatelessWidget {
  const _Tag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// The gentle effect: whitened, slightly softened, faded out at the edges of
/// the lips box so it blends in. Plain Flutter only.
class SmileEffect extends StatelessWidget {
  const SmileEffect({super.key, required this.lipsBox, required this.child});

  final Rect lipsBox;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (bounds) => _lipsMask(lipsBox),
      child: ImageFiltered(
        imageFilter: ui.ImageFilter.blur(sigmaX: 0.7, sigmaY: 0.7),
        child: ColorFiltered(
          colorFilter: const ColorFilter.matrix(kWhiteningMatrix),
          child: child,
        ),
      ),
    );
  }

  /// An elliptical mask: opaque in the middle of the box, fading at its edges.
  static Shader _lipsMask(Rect box) {
    final center = box.center;
    final radius = box.width / 2;
    final squash = box.height / box.width;
    final matrix = Matrix4.identity()
      ..translateByDouble(center.dx, center.dy, 0, 1)
      ..scaleByDouble(1, squash, 1, 1)
      ..translateByDouble(-center.dx, -center.dy, 0, 1);
    return ui.Gradient.radial(
      center,
      radius,
      const [Colors.white, Colors.white, Color(0x00FFFFFF)],
      const [0, 0.55, 1],
      TileMode.clamp,
      matrix.storage,
    );
  }
}
