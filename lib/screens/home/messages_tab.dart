import 'dart:async';

import 'package:flutter/material.dart';

import '../../api/api_client.dart';
import '../../api/models.dart';
import '../../config.dart';
import '../../theme.dart';
import '../../util/dates.dart';
import '../../widgets/common.dart';

/// A chat with the clinic. Looks for new messages every 30 s while open.
class MessagesTab extends StatefulWidget {
  const MessagesTab({super.key, required this.api, required this.active});

  final ApiClient api;

  /// True while this tab is the one on screen.
  final bool active;

  @override
  State<MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab> with WidgetsBindingObserver {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  List<Message>? _messages;
  String? _error;
  bool _sending = false;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.active) {
      _start();
    }
  }

  @override
  void didUpdateWidget(MessagesTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _start();
    } else if (!widget.active && oldWidget.active) {
      _stop();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!widget.active) {
      return;
    }
    if (state == AppLifecycleState.resumed) {
      _start();
    } else if (state == AppLifecycleState.paused) {
      _stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stop();
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _start() {
    _load();
    _poll?.cancel();
    _poll = Timer.periodic(AppConfig.messagesPollInterval, (_) => _load());
  }

  void _stop() {
    _poll?.cancel();
    _poll = null;
  }

  Future<void> _load() async {
    try {
      final messages = await widget.api.messages();
      if (!mounted) {
        return;
      }
      final grew = (_messages?.length ?? 0) != messages.length;
      setState(() {
        _messages = messages;
        _error = null;
      });
      if (grew) {
        _scrollToEnd();
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _error = e.message);
      }
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final body = _input.text.trim();
    if (body.isEmpty || _sending) {
      return;
    }
    setState(() => _sending = true);
    try {
      final message = await widget.api.sendMessage(body);
      _input.clear();
      setState(() => _messages = [...?_messages, message]);
      _scrollToEnd();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    final messages = _messages;
    return SafeArea(
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: PageTitle(
                    'Messages',
                    subtitle: 'Write to your clinic. They usually answer within a working day.',
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _load,
                  child: messages == null
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          children: [
                            if (_error != null)
                              CalmMessage(
                                icon: Icons.wifi_off_rounded,
                                title: 'Messages didn\'t load',
                                body: _error,
                                actionLabel: 'Try again',
                                onAction: _load,
                              )
                            else
                              const Padding(
                                padding: EdgeInsets.all(32),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          ],
                        )
                      : messages.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          children: const [
                            CalmMessage(
                              icon: Icons.chat_bubble_outline_rounded,
                              title: 'No messages yet',
                              body: 'Questions about your aligners? Write to your clinic here.',
                            ),
                          ],
                        )
                      : ListView.builder(
                          controller: _scroll,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                          itemCount: messages.length,
                          itemBuilder: (context, i) =>
                              MessageBubble(message: messages[i]),
                        ),
                ),
              ),
              Container(
                color: palette.card,
                padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        key: const Key('message-input'),
                        controller: _input,
                        minLines: 1,
                        maxLines: 5,
                        maxLength: 4000,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: 'Message your clinic',
                          counterText: '',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton.filled(
                      key: const Key('message-send'),
                      onPressed: _sending ? null : _send,
                      style: IconButton.styleFrom(
                        backgroundColor: ShineColors.teal,
                        foregroundColor: ShineColors.ink,
                      ),
                      icon: const Icon(Icons.arrow_upward_rounded),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Clinic on the left, the patient on the right.
class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    final mine = message.author == MessageAuthor.patient;
    final at = message.at;
    final meta = [
      if (!mine && message.name != null) message.name!,
      if (at != null) '${shortDate(at)}, ${clockTime(at)}',
    ].join(' · ');
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width.clamp(0, 640) * 0.78,
        ),
        child: Column(
          crossAxisAlignment: mine
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: mine ? ShineColors.teal : palette.card,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(mine ? 20 : 6),
                  bottomRight: Radius.circular(mine ? 6 : 20),
                ),
              ),
              child: Text(
                message.body,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.35,
                  color: mine ? ShineColors.ink : palette.ink,
                ),
              ),
            ),
            if (meta.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 6, 0),
                child: Text(
                  meta,
                  style: TextStyle(fontSize: 12, color: palette.muted),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
