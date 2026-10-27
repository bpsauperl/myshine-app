import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

import '../api/api_client.dart';
import '../l10n/l10n.dart';
import '../state/session.dart';
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
    final l10n = context.l10n;
    final problem = ConnectCode.validate(_controller.text, l10n);
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
        () => _error = e.statusCode == 422
            ? e.messageFor('code')
            : l10n.apiError(e),
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.kit;
    final l10n = context.l10n;
    final complete =
        ConnectCode.normalize(_controller.text).length == ConnectCode.length;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              KitSize.gutter + 4,
              8,
              KitSize.gutter + 4,
              24,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 480,
                  minHeight: constraints.maxHeight - 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: KitRoundButton(
                            icon: Icons.arrow_back_rounded,
                            label: l10n.commonBack,
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                        ),
                        const SizedBox(height: 28),
                        KitHeadline(
                          title: l10n.connectTitle,
                          muted: l10n.connectTitleMuted,
                          size: 44,
                          body: l10n.connectBody,
                        ),
                        const SizedBox(height: 28),
                        KitTile(
                          radius: 26,
                          padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  const Wordmark(size: 16),
                                  Text(
                                    ' ${l10n.connectPass}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: p.ink,
                                      letterSpacing: -0.4,
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(Icons.key_rounded, color: p.accentText),
                                ],
                              ),
                              const SizedBox(height: 14),
                              TextField(
                                key: const Key('connect-code'),
                                controller: _controller,
                                autofocus: true,
                                enabled: !_busy,
                                autocorrect: false,
                                enableSuggestions: false,
                                textCapitalization:
                                    TextCapitalization.characters,
                                keyboardType: TextInputType.visiblePassword,
                                inputFormatters: [ConnectCodeInputFormatter()],
                                style: KitType.display(
                                  34,
                                  color: p.ink,
                                ).copyWith(letterSpacing: 3),
                                decoration: InputDecoration(
                                  filled: false,
                                  hintText: 'ABCD-2345',
                                  hintStyle: KitType.display(
                                    34,
                                    color: p.hairline,
                                  ).copyWith(letterSpacing: 3),
                                  errorText: _error,
                                  errorMaxLines: 3,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: p.hairline),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: p.hairline),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: p.accent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                onChanged: (_) => setState(() => _error = null),
                                onSubmitted: (_) => _connect(),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.connectWorksOnce,
                                    style: KitType.label(color: p.secondary)
                                        .copyWith(fontSize: 12),
                                  ),
                                  Text(
                                    l10n.connectValidDays(14),
                                    style: KitType.label(color: p.secondary)
                                        .copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 28),
                      child: Column(
                        children: [
                          KitButton(
                            key: const Key('connect-button'),
                            label: l10n.connectButton,
                            trailingIcon: Icons.arrow_forward_rounded,
                            busy: _busy,
                            onPressed: complete ? _connect : null,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            l10n.connectFooter,
                            textAlign: TextAlign.center,
                            style: KitType.label(color: p.secondary),
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
      ),
    );
  }
}
