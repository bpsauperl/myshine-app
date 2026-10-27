import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

import '../../api/api_client.dart';
import '../../api/models.dart';
import '../../config.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import 'check_in_camera_screen.dart';

/// The fit choices, in the API's words and the patient's.
const Map<String, String> kFitOptions = {
  'seated': 'Fits well',
  'loose': 'Not fully seated',
  'tight': 'Very tight',
  'damaged': 'Damaged or lost',
};

/// Fits where a photo helps the clinic most.
const Set<String> kFitsAskingForPhotos = {'loose', 'tight', 'damaged'};

const Map<String, String> kComfortOptions = {
  'none': 'None',
  'mild': 'Mild',
  'strong': 'Strong',
};

/// "How is your aligner?" — posts to `/check-ins` (with up to 3 photos), then
/// says thank you.
class CheckInCard extends StatefulWidget {
  const CheckInCard({
    super.key,
    required this.api,
    this.aligner,
    this.onSent,
    this.cameraSupported = !kIsWeb,
    this.takePhoto = CheckInCameraScreen.take,
  });

  final ApiClient api;
  final int? aligner;
  final ValueChanged<CheckIn>? onSent;

  /// False on web: photos can only be taken in the phone app.
  final bool cameraSupported;

  /// Opens the in-app camera; tests pass a fake.
  final Future<CheckInPhoto?> Function(BuildContext context) takePhoto;

  @override
  State<CheckInCard> createState() => _CheckInCardState();
}

class _CheckInCardState extends State<CheckInCard> {
  final _notes = TextEditingController();
  String? _fit;
  int _hours = AppConfig.wearHoursGoal;
  String? _comfort;
  final List<CheckInPhoto> _photos = [];
  bool _sending = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final fit = _fit;
    if (fit == null) {
      setState(() => _error = 'Choose how your aligner fits.');
      return;
    }
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      final checkIn = await widget.api.sendCheckIn(
        CheckInDraft(
          fit: fit,
          wearHours: _hours,
          comfort: _comfort,
          notes: _notes.text,
          photos: List.of(_photos),
        ),
      );
      widget.onSent?.call(checkIn);
      setState(() => _sent = true);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  void _reset() {
    setState(() {
      _sent = false;
      _fit = null;
      _hours = AppConfig.wearHoursGoal;
      _comfort = null;
      _photos.clear();
      _notes.clear();
    });
  }

  Future<void> _addPhoto() async {
    final photo = await widget.takePhoto(context);
    if (photo == null || !mounted || _photos.length >= CheckInDraft.maxPhotos) {
      return;
    }
    setState(() => _photos.add(photo));
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    if (_sent) {
      return ShineCard(
        key: const Key('check-in-thanks'),
        color: palette.accentSoft,
        child: Column(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: palette.accentText,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text('Thank you!', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              'Your clinic sees your check-in and will get in touch if anything needs to change.',
              textAlign: TextAlign.center,
              style: TextStyle(color: palette.ink, height: 1.4),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _reset,
              child: const Text('Send another check-in'),
            ),
          ],
        ),
      );
    }

    final title = widget.aligner == null
        ? 'How is your aligner?'
        : 'How is aligner ${widget.aligner}?';
    return ShineCard(
      color: context.kit.inset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your check-in',
            style: KitType.eyebrow(color: palette.accentText),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: KitType.title(color: palette.ink).copyWith(fontSize: 26),
          ),
          const SizedBox(height: 16),
          _Label('Fit'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final entry in kFitOptions.entries)
                ChoiceChip(
                  key: Key('fit-${entry.key}'),
                  label: Text(entry.value),
                  selected: _fit == entry.key,
                  showCheckmark: false,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _fit == entry.key
                        ? (context.kit.isDark ? Colors.black : Colors.white)
                        : palette.ink,
                  ),
                  onSelected: _sending
                      ? null
                      : (_) => setState(() {
                          _fit = entry.key;
                          _error = null;
                        }),
                ),
            ],
          ),
          const SizedBox(height: 20),
          _Label('Hours a day'),
          Row(
            children: [
              _StepButton(
                key: const Key('hours-minus'),
                icon: Icons.remove_rounded,
                onPressed: _sending || _hours <= 0
                    ? null
                    : () => setState(() => _hours--),
              ),
              Expanded(
                child: Text(
                  '$_hours h',
                  key: const Key('hours-value'),
                  textAlign: TextAlign.center,
                  style: KitType.number(size: 30, color: palette.ink),
                ),
              ),
              _StepButton(
                key: const Key('hours-plus'),
                icon: Icons.add_rounded,
                onPressed: _sending || _hours >= 24
                    ? null
                    : () => setState(() => _hours++),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _Label('Discomfort'),
          Wrap(
            spacing: 8,
            children: [
              for (final entry in kComfortOptions.entries)
                ChoiceChip(
                  key: Key('comfort-${entry.key}'),
                  label: Text(entry.value),
                  selected: _comfort == entry.key,
                  showCheckmark: false,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _comfort == entry.key
                        ? (context.kit.isDark ? Colors.black : Colors.white)
                        : palette.ink,
                  ),
                  onSelected: _sending
                      ? null
                      : (selected) => setState(
                          () => _comfort = selected ? entry.key : null,
                        ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          _PhotosSection(
            photos: _photos,
            asking: kFitsAskingForPhotos.contains(_fit),
            cameraSupported: widget.cameraSupported,
            enabled: !_sending,
            onAdd: _addPhoto,
            onRemove: (index) => setState(() => _photos.removeAt(index)),
          ),
          const SizedBox(height: 20),
          _Label('Notes for your clinic'),
          TextField(
            key: const Key('check-in-notes'),
            controller: _notes,
            enabled: !_sending,
            minLines: 2,
            maxLines: 5,
            maxLength: 2000,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Anything you\'d like them to know (optional)',
              counterText: '',
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton(
            key: const Key('check-in-send'),
            onPressed: _sending ? null : _send,
            child: Text(_sending ? 'Sending…' : 'Send check-in'),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: context.shine.muted,
        ),
      ),
    );
  }
}

/// "Add photos": up to 3 thumbnails, each with a remove button, and an add
/// tile. On web a calm note instead, since the camera works only in the app.
class _PhotosSection extends StatelessWidget {
  const _PhotosSection({
    required this.photos,
    required this.asking,
    required this.cameraSupported,
    required this.enabled,
    required this.onAdd,
    required this.onRemove,
  });

  final List<CheckInPhoto> photos;

  /// The fit is a problem: explain why a photo helps.
  final bool asking;
  final bool cameraSupported;
  final bool enabled;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final kit = context.kit;
    final hint = asking
        ? 'A photo of the aligner helps your clinic see what\'s wrong.'
        : 'Optional. Up to ${CheckInDraft.maxPhotos} photos, only your clinic sees them.';
    return Column(
      key: const Key('check-in-photos'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label('Photos'),
        if (!cameraSupported)
          Container(
            key: const Key('photos-unavailable'),
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: kit.tile,
              borderRadius: BorderRadius.circular(KitSize.tileRadius),
            ),
            child: Row(
              children: [
                Icon(Icons.photo_camera_outlined, color: kit.secondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'You can add photos of your aligner in the myShine app on your phone.',
                    style: KitType.label(color: kit.secondary),
                  ),
                ),
              ],
            ),
          )
        else ...[
          Text(
            hint,
            key: const Key('photos-hint'),
            style: KitType.label(
              color: asking ? kit.accentText : kit.secondary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: KitSize.gap,
            runSpacing: KitSize.gap,
            children: [
              for (var i = 0; i < photos.length; i++)
                _PhotoThumb(
                  key: Key('photo-$i'),
                  photo: photos[i],
                  onRemove: enabled ? () => onRemove(i) : null,
                ),
              if (photos.length < CheckInDraft.maxPhotos)
                _AddPhotoTile(
                  key: const Key('photo-add'),
                  onPressed: enabled ? onAdd : null,
                ),
            ],
          ),
        ],
      ],
    );
  }
}

const double _kThumbSize = 84;

class _PhotoThumb extends StatelessWidget {
  const _PhotoThumb({super.key, required this.photo, this.onRemove});

  final CheckInPhoto photo;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final kit = context.kit;
    return SizedBox(
      width: _kThumbSize,
      height: _kThumbSize,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.memory(
              photo.bytes,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              errorBuilder: (_, _, _) => ColoredBox(
                color: kit.tile,
                child: Icon(Icons.image_outlined, color: kit.secondary),
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: Semantics(
              button: true,
              label: 'Remove photo',
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

class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final kit = context.kit;
    return Semantics(
      button: true,
      label: 'Add a photo',
      child: Material(
        color: kit.tile,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onPressed,
          child: SizedBox(
            width: _kThumbSize,
            height: _kThumbSize,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo_outlined, color: kit.accentText),
                const SizedBox(height: 4),
                Text('Add', style: KitType.label(color: kit.accentText)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({super.key, required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: context.kit.tile,
        foregroundColor: context.shine.ink,
        minimumSize: const Size(48, 48),
      ),
    );
  }
}
