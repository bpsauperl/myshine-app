import 'package:flutter/material.dart';

import '../config.dart';
import '../state/session.dart';
import '../theme.dart';

/// The hidden "Server" setting (long-press the logo on the welcome screen).
Future<void> showServerSettings(BuildContext context, Session session) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: context.shine.card,
    builder: (context) => _ServerSettingsSheet(session: session),
  );
}

class _ServerSettingsSheet extends StatefulWidget {
  const _ServerSettingsSheet({required this.session});

  final Session session;

  @override
  State<_ServerSettingsSheet> createState() => _ServerSettingsSheetState();
}

class _ServerSettingsSheetState extends State<_ServerSettingsSheet> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.session.baseUrl,
  );
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save([String? value]) async {
    final text = (value ?? _controller.text).trim();
    final uri = Uri.tryParse(text);
    if (text.isNotEmpty &&
        (uri == null ||
            !(uri.isScheme('http') || uri.isScheme('https')) ||
            uri.host.isEmpty)) {
      setState(() => _error = 'Use a full address, like https://example.com');
      return;
    }
    await widget.session.setBaseUrl(text);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Server', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(
            'For testing only. The app talks to this drShine server.',
            style: TextStyle(color: context.shine.muted),
          ),
          const SizedBox(height: 16),
          TextField(
            key: const Key('server-url'),
            controller: _controller,
            keyboardType: TextInputType.url,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: AppConfig.defaultBaseUrl,
              errorText: _error,
            ),
            onSubmitted: _save,
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _save, child: const Text('Save')),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _save(''),
            child: const Text('Use the default server'),
          ),
        ],
      ),
    );
  }
}
