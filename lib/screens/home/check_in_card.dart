import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

import '../../api/api_client.dart';
import '../../api/models.dart';
import '../../l10n/l10n.dart';
import '../../theme.dart';
import '../../util/dates.dart';
import '../../widgets/common.dart';
import '../../widgets/photo_thumb.dart';
import 'photo_camera_screen.dart';

/// The fit choices, in the API's words and the patient's.
Map<String, String> fitOptions(AppLocalizations l10n) => {
  'seated': l10n.checkInFitSeated,
  'loose': l10n.checkInFitLoose,
  'tight': l10n.checkInFitTight,
  'damaged': l10n.checkInFitDamaged,
};

/// Fits where a photo helps the clinic most.
const Set<String> kFitsAskingForPhotos = {'loose', 'tight', 'damaged'};

Map<String, String> comfortOptions(AppLocalizations l10n) => {
  'none': l10n.checkInComfortNone,
  'mild': l10n.checkInComfortMild,
  'strong': l10n.checkInComfortStrong,
};

/// The aligner change: when check-in is on, the patient confirms they put in
/// the next aligner and says how it fits (discomfort, a note, up to five
/// optional intraoral photos). Until the change is due, a quiet line says when
/// it is, with a way to check in early. The schedule follows each change.
class CheckInCard extends StatefulWidget {
  const CheckInCard({
    super.key,
    required this.api,
    required this.checkIn,
    this.onSent,
    this.now,
    this.cameraSupported,
    this.takePhoto,
  });

  final ApiClient api;

  /// Which aligner is next and when it is due ([CheckInState.canCheckIn]).
  final CheckInState checkIn;
  final ValueChanged<CheckIn>? onSent;

  /// Today, for tests.
  final DateTime? now;

  /// False on web: photos can only be taken in the phone app. Defaults to
  /// [PhotoCapture.supported].
  final bool? cameraSupported;

  /// Opens the in-app camera; tests pass a fake. Defaults to [PhotoCapture].
  final PhotoTaker? takePhoto;

  bool get _cameraSupported => cameraSupported ?? PhotoCapture.supported;

  PhotoTaker get _takePhoto => takePhoto ?? PhotoCapture.take;

  @override
  State<CheckInCard> createState() => _CheckInCardState();
}

class _CheckInCardState extends State<CheckInCard> {
  final _notes = TextEditingController();
  bool _switched = false;
  String? _fit;
  String? _comfort;
  final Map<IntraoralView, PhotoUpload> _photos = {};
  bool _sending = false;
  bool _early = false;

  /// The aligner just checked in, until the schedule moves on to the next.
  int? _sentAligner;
  String? _error;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  int get _aligner => widget.checkIn.nextAligner!;

  bool get _isDue {
    final dueOn = widget.checkIn.dueOn;
    final today = dateOnly(widget.now ?? DateTime.now());
    return widget.checkIn.lateDays > 0 ||
        dueOn == null ||
        !dateOnly(dueOn).isAfter(today);
  }

  Future<void> _send() async {
    final fit = _fit;
    final l10n = context.l10n;
    if (!_switched) {
      setState(() => _error = l10n.checkInConfirmError(_aligner));
      return;
    }
    if (fit == null) {
      setState(() => _error = l10n.checkInChooseFitError(_aligner));
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
          comfort: _comfort,
          notes: _notes.text,
          photos: Map.of(_photos),
        ),
      );
      setState(() {
        _sentAligner = checkIn.aligner ?? _aligner;
        _switched = false;
        _fit = null;
        _comfort = null;
        _photos.clear();
        _notes.clear();
        _early = false;
      });
      widget.onSent?.call(checkIn);
    } on ApiException catch (e) {
      setState(() => _error = l10n.apiError(e));
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  Future<void> _takePhoto(IntraoralView view) async {
    final l10n = context.l10n;
    final photo = await widget._takePhoto(
      context,
      PhotoPrompt(
        title: l10n.checkInPhotoTitle(l10n.intraoralLabel(view)),
        hint: l10n.intraoralHint(view),
      ),
    );
    if (photo == null || !mounted) {
      return;
    }
    setState(() => _photos[view] = photo);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.checkIn.canCheckIn) {
      return const SizedBox.shrink();
    }
    // Waiting for the schedule to move on after a check-in, or not due yet.
    final waiting = _sentAligner != null && _sentAligner! >= _aligner;
    if (waiting || (!_isDue && !_early)) {
      return _upcoming(context);
    }
    return _form(context);
  }

  Widget _upcoming(BuildContext context) {
    final kit = context.kit;
    final l10n = context.l10n;
    final dueOn = widget.checkIn.dueOn;
    final waiting = _sentAligner != null && _sentAligner! >= _aligner;
    final thanks = _sentAligner;
    return ShineCard(
      key: const Key('check-in-upcoming'),
      color: thanks != null ? kit.accentSoft : kit.inset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (thanks != null) ...[
            Row(
              key: const Key('check-in-thanks'),
              children: [
                Icon(Icons.check_circle_rounded, color: kit.accentText),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.checkInThanks(thanks),
                    style: KitType.body(color: kit.ink)
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          if (!waiting) ...[
            Text(
              l10n.checkInEyebrow,
              style: KitType.eyebrow(color: kit.accentText),
            ),
            const SizedBox(height: 4),
            Text(
              dueOn == null
                  ? l10n.checkInNext(_aligner)
                  : l10n.checkInAlignerWhen(
                      _aligner,
                      relativeDay(l10n, dueOn, now: widget.now),
                    ),
              style: KitType.title(color: kit.ink).copyWith(fontSize: 22),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.checkInUpcomingBody,
              style: KitType.body(color: kit.secondary),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                key: const Key('check-in-early'),
                onPressed: () => setState(() {
                  _early = true;
                  _sentAligner = null;
                }),
                child: Text(l10n.checkInEarly(_aligner)),
              ),
            ),
          ] else
            Text(
              l10n.checkInClinicSees,
              style: KitType.body(color: kit.secondary),
            ),
        ],
      ),
    );
  }

  Widget _form(BuildContext context) {
    final palette = context.shine;
    final kit = context.kit;
    final l10n = context.l10n;
    final late = widget.checkIn.lateDays;
    final dueOn = widget.checkIn.dueOn;
    final status = late == 1
        ? l10n.checkInDueYesterday
        : late > 1
        ? l10n.checkInDueDaysAgo(late)
        : dueOn == null
        ? null
        : l10n.checkInDue(relativeDay(l10n, dueOn, now: widget.now));
    return ShineCard(
      key: const Key('check-in-form'),
      color: kit.inset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.checkInEyebrow,
            style: KitType.eyebrow(color: palette.accentText),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.checkInSwitchTitle(_aligner),
            style: KitType.title(color: palette.ink).copyWith(fontSize: 26),
          ),
          if (status != null) ...[
            const SizedBox(height: 4),
            Text(
              status,
              key: const Key('check-in-status'),
              style: KitType.label(color: kit.secondary),
            ),
          ],
          const SizedBox(height: 16),
          Material(
            color: _switched ? kit.accentSoft : kit.tile,
            borderRadius: BorderRadius.circular(KitSize.tileRadius),
            child: SwitchListTile.adaptive(
              key: const Key('check-in-switched'),
              value: _switched,
              onChanged: _sending
                  ? null
                  : (value) => setState(() {
                      _switched = value;
                      _error = null;
                    }),
              title: Text(
                l10n.checkInSwitchedLabel(_aligner),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: palette.ink,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(KitSize.tileRadius),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _Label(l10n.checkInFitQuestion(_aligner)),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final entry in fitOptions(l10n).entries)
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
          _Label(l10n.checkInDiscomfort),
          Wrap(
            spacing: 8,
            children: [
              for (final entry in comfortOptions(l10n).entries)
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
            cameraSupported: widget._cameraSupported,
            enabled: !_sending,
            onTake: _takePhoto,
            onRemove: (view) => setState(() => _photos.remove(view)),
          ),
          const SizedBox(height: 20),
          _Label(l10n.checkInNoteLabel),
          TextField(
            key: const Key('check-in-notes'),
            controller: _notes,
            enabled: !_sending,
            minLines: 2,
            maxLines: 5,
            maxLength: 2000,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: l10n.checkInNoteHint,
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
            child: Text(
              _sending ? l10n.checkInSending : l10n.checkInSend(_aligner),
            ),
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

/// "Photos": the five intraoral views, each a tile to take or remove. All
/// optional. On web a calm note instead, since the camera works only in the
/// app.
class _PhotosSection extends StatelessWidget {
  const _PhotosSection({
    required this.photos,
    required this.asking,
    required this.cameraSupported,
    required this.enabled,
    required this.onTake,
    required this.onRemove,
  });

  final Map<IntraoralView, PhotoUpload> photos;

  /// The fit is a problem: explain why photos help.
  final bool asking;
  final bool cameraSupported;
  final bool enabled;
  final ValueChanged<IntraoralView> onTake;
  final ValueChanged<IntraoralView> onRemove;

  @override
  Widget build(BuildContext context) {
    final kit = context.kit;
    final l10n = context.l10n;
    final hint = asking ? l10n.checkInPhotosAsking : l10n.checkInPhotosOptional;
    return Column(
      key: const Key('check-in-photos'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(l10n.checkInPhotos),
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
                    l10n.checkInPhotosWebOnly,
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
              for (final view in IntraoralView.values)
                photos[view] == null
                    ? _TakePhotoTile(
                        key: Key('photo-take-${view.key}'),
                        label: l10n.intraoralLabel(view),
                        onPressed: enabled ? () => onTake(view) : null,
                      )
                    : PhotoThumb(
                        key: Key('photo-${view.key}'),
                        bytes: photos[view]!.bytes,
                        label: l10n.intraoralLabel(view),
                        onRemove: enabled ? () => onRemove(view) : null,
                      ),
            ],
          ),
        ],
      ],
    );
  }
}

class _TakePhotoTile extends StatelessWidget {
  const _TakePhotoTile({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final kit = context.kit;
    return Semantics(
      button: true,
      label: context.l10n.checkInTakePhoto(label),
      excludeSemantics: true,
      child: Material(
        color: kit.tile,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onPressed,
          child: SizedBox(
            width: kPhotoThumbSize,
            height: kPhotoThumbSize,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo_outlined, color: kit.accentText),
                const SizedBox(height: 4),
                Text(label, style: KitType.label(color: kit.accentText)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
