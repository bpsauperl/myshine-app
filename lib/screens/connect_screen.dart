import 'package:flutter/material.dart';

import '../api/api_client.dart';
import '../state/session.dart';
import '../theme.dart';
import '../util/connect_code.dart';
import '../widgets/common.dart';

/// The patient types the 8-character code from their clinic.
class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  final _controller = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    final problem = ConnectCode.validate(_controller.text);
    if (problem != null) {
      setState(() => _error = problem);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final navigator = Navigator.of(context);
    try {
      await SessionScope.of(context)
          .connect(ConnectCode.format(_controller.text));
      navigator.popUntil((route) => route.isFirst);
    } on ApiException catch (e) {
      setState(
        () => _error = e.statusCode == 422 ? e.messageFor('code') : e.message,
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    final complete =
        ConnectCode.normalize(_controller.text).length == ConnectCode.length;
    return Scaffold(
      backgroundColor: palette.card,
      appBar: AppBar(backgroundColor: palette.card),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connect with your clinic',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your clinic gives you a code with 8 characters. '
                    'Type it here to see your plan, your aligners and messages.',
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.4,
                      color: palette.muted,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    key: const Key('connect-code'),
                    controller: _controller,
                    autofocus: true,
                    enabled: !_busy,
                    textAlign: TextAlign.center,
                    autocorrect: false,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.characters,
                    keyboardType: TextInputType.visiblePassword,
                    inputFormatters: [ConnectCodeInputFormatter()],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 4,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                    decoration: InputDecoration(
                      hintText: 'ABCD-2345',
                      hintStyle: TextStyle(
                        color: palette.muted.withValues(alpha: 0.5),
                      ),
                      errorText: _error,
                      errorMaxLines: 3,
                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    onChanged: (_) => setState(() => _error = null),
                    onSubmitted: (_) => _connect(),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    key: const Key('connect-button'),
                    onPressed: _busy || !complete ? null : _connect,
                    child: _busy
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: palette.card,
                            ),
                          )
                        : const Text('Connect'),
                  ),
                  const SizedBox(height: 24),
                  ShineCard(
                    color: palette.accentSoft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: palette.accentText),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'The code works once and for 14 days. If it doesn\'t work, '
                            'ask your clinic for a new one.',
                            style: TextStyle(height: 1.4, color: palette.ink),
                          ),
                        ),
                      ],
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
