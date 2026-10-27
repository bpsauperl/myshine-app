import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

const double kPhotoThumbSize = 84;

/// A square photo not yet sent, with an optional caption and a remove button.
class PhotoThumb extends StatelessWidget {
  const PhotoThumb({
    super.key,
    required this.bytes,
    this.label,
    this.size = kPhotoThumbSize,
    this.onRemove,
  });

  final Uint8List bytes;
  final String? label;
  final double size;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final kit = context.kit;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.memory(
              bytes,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              errorBuilder: (_, _, _) => ColoredBox(
                color: kit.tile,
                child: Icon(Icons.image_outlined, color: kit.secondary),
              ),
            ),
          ),
          if (label != null)
            Positioned(
              left: 6,
              bottom: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  label!,
                  style: KitType.label(color: Colors.white)
                      .copyWith(fontSize: 11),
                ),
              ),
            ),
          Positioned(
            top: 4,
            right: 4,
            child: Semantics(
              button: true,
              label: label == null ? 'Remove photo' : 'Remove the $label photo',
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
