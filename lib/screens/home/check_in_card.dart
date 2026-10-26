import 'package:flutter/material.dart';

import '../../api/api_client.dart';
import '../../api/models.dart';
import '../../config.dart';
import '../../theme.dart';
import '../../widgets/common.dart';

/// The fit choices, in the API's words and the patient's.
const Map<String, String> kFitOptions = {
  'seated': 'Fits well',
  'loose': 'Not fully seated',
  'tight': 'Very tight',
  'damaged': 'Damaged or lost',
};

const Map<String, String> kComfortOptions = {
  'none': 'None',
  'mild': 'Mild',
  'strong': 'Strong',
};

/// "How is your aligner?" — posts to `/check-ins`, then says thank you.
class CheckInCard extends StatefulWidget {
  const CheckInCard({super.key, required this.api, this.aligner, this.onSent});

  final ApiClient api;
  final int? aligner;
  final ValueChanged<CheckIn>? onSent;

  @override
  State<CheckInCard> createState() => _CheckInCardState();
}

class _CheckInCardState extends State<CheckInCard> {
  final _notes = TextEditingController();
  String? _fit;
  int _hours = AppConfig.wearHoursGoal;
  String? _comfort;
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
      _notes.clear();
    });
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Check in',
            style: TextStyle(
              color: palette.accentText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
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
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
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
                  onSelected: _sending
                      ? null
                      : (selected) => setState(
                          () => _comfort = selected ? entry.key : null,
                        ),
                ),
            ],
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
        backgroundColor: context.shine.background,
        foregroundColor: context.shine.ink,
        minimumSize: const Size(48, 48),
      ),
    );
  }
}
