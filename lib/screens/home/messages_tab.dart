import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

import '../../api/api_client.dart';
import '../../api/models.dart';
import '../../config.dart';
import '../../l10n/l10n.dart';
import '../../theme.dart';
import '../../util/dates.dart';
import '../../widgets/common.dart';
import '../../widgets/photo_thumb.dart';
import 'photo_camera_screen.dart';

/// A chat with the clinic, with photos as attachments (up to
/// [maxMessagePhotos] per message). Looks for new messages every 30 s while
/// open.
class MessagesTab extends StatefulWidget {
  const MessagesTab({
    super.key,
    required this.api,
    required this.active,
    this.cameraSupported,
    this.takePhoto,
  });

  final ApiClient api;

  /// True while this tab is the one on screen.
  final bool active;

  /// False on web: photos can only be attached in the phone app. Defaults to
  /// [PhotoCapture.supported].
  final bool? cameraSupported;

  /// Opens the in-app camera; tests pass a fake. Defaults to [PhotoCapture].
  final PhotoTaker? takePhoto;

  bool get _cameraSupported => cameraSupported ?? PhotoCapture.supported;

  PhotoTaker get _takePhoto => takePhoto ?? PhotoCapture.take;

  @override
  State<MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab> with WidgetsBindingObserver {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  List<Message>? _messages;
  final List<PhotoUpload> _attachments = [];
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
        setState(() => _error = context.l10n.apiError(e));
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
    if ((body.isEmpty && _attachments.isEmpty) || _sending) {
      return;
    }
    setState(() => _sending = true);
    try {
      final message = await widget.api.sendMessage(
        body,
        photos: List.of(_attachments),
      );
      _input.clear();
      setState(() {
        _attachments.clear();
        _messages = [...?_messages, message];
      });
      _scrollToEnd();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.apiError(e))));
      }
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  Future<void> _attachPhoto() async {
    final l10n = context.l10n;
    final photo = await widget._takePhoto(
      context,
      PhotoPrompt(title: l10n.messagesPhotoTitle, hint: l10n.messagesPhotoHint),
    );
    if (photo == null || !mounted || _attachments.length >= maxMessagePhotos) {
      return;
    }
    setState(() => _attachments.add(photo));
  }

  @override
  Widget build(BuildContext context) {
    final messages = _messages;
    final l10n = context.l10n;
    final canAttach =
        widget._cameraSupported && _attachments.length < maxMessagePhotos;
    return SafeArea(
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: PageTitle(
                    l10n.messagesTitle,
                    subtitle: l10n.messagesSubtitle,
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
                                title: l10n.messagesLoadError,
                                body: _error,
                                actionLabel: l10n.commonTryAgain,
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
                          children: [
                            CalmMessage(
                              icon: Icons.chat_bubble_outline_rounded,
                              title: l10n.messagesEmptyTitle,
                              body: l10n.messagesEmptyBody,
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
              if (_attachments.isNotEmpty)
                Padding(
                  key: const Key('message-attachments'),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: KitSize.gap,
                      children: [
                        for (var i = 0; i < _attachments.length; i++)
                          PhotoThumb(
                            key: Key('attachment-$i'),
                            bytes: _attachments[i].bytes,
                            size: 64,
                            onRemove: _sending
                                ? null
                                : () =>
                                      setState(() => _attachments.removeAt(i)),
                          ),
                      ],
                    ),
                  ),
                ),
              // Sits above the floating tab bar.
              Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 108),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (widget._cameraSupported) ...[
                      ComposerButton(
                        key: const Key('message-attach'),
                        tooltip: l10n.messagesAddPhoto,
                        icon: Icons.photo_camera_outlined,
                        onPressed: _sending || !canAttach ? null : _attachPhoto,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: TextField(
                        key: const Key('message-input'),
                        controller: _input,
                        minLines: 1,
                        maxLines: 5,
                        maxLength: 4000,
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: l10n.messagesInputHint,
                          counterText: '',
                          isDense: true,
                          filled: true,
                          fillColor: context.shine.card,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide(color: context.shine.ink, width: 1.2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ComposerButton(
                      key: const Key('message-send'),
                      tooltip: l10n.messagesSend,
                      icon: Icons.arrow_upward_rounded,
                      filled: true,
                      onPressed: _sending ? null : _send,
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

/// A 44 px round button next to the message field: grey, or black for sending.
class ComposerButton extends StatelessWidget {
  const ComposerButton({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.filled = false,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final onInk = dark ? Colors.black : Colors.white;
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        enabled: onPressed != null,
        label: tooltip,
        excludeSemantics: true,
        child: Material(
          color: filled ? (onPressed == null ? palette.hairline : palette.ink) : palette.card,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Icon(icon, size: filled ? 20 : 21, color: filled ? onInk : palette.ink),
            ),
          ),
        ),
      ),
    );
  }
}

/// Clinic on the left in grey, the patient on the right in black.
class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    final l10n = context.l10n;
    final mine = message.author == MessageAuthor.patient;
    final at = message.at;
    final meta = [
      if (!mine && message.name != null) message.name!,
      if (at != null) '${shortDate(l10n, at)}, ${clockTime(at)}',
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
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
              decoration: BoxDecoration(
                color: mine ? palette.ink : palette.card,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(mine ? 20 : 6),
                  bottomRight: Radius.circular(mine ? 6 : 20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.photos.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final photo in message.photos)
                          _MessagePhotoTile(photo: photo),
                      ],
                    ),
                  if (message.photos.isNotEmpty && message.body.isNotEmpty)
                    const SizedBox(height: 8),
                  if (message.body.isNotEmpty)
                    Text(
                      message.body,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.35,
                        color: mine
                            ? (Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white)
                            : palette.ink,
                      ),
                    ),
                ],
              ),
            ),
            if (meta.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 6, 0),
                child: Text(
                  meta,
                  style: const TextStyle(fontSize: 11, color: ShineColors.tertiary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A photo in a message bubble; a tap opens it full screen.
class _MessagePhotoTile extends StatelessWidget {
  const _MessagePhotoTile({required this.photo});

  final MessagePhoto photo;

  @override
  Widget build(BuildContext context) {
    final kit = context.kit;
    return Semantics(
      button: true,
      label: context.l10n.messagesOpenPhoto,
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => _PhotoViewer(url: photo.url)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.network(
            photo.url,
            key: Key('message-photo-${photo.id}'),
            width: 120,
            height: 150,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: 120,
              height: 150,
              color: kit.tile,
              child: Icon(Icons.image_outlined, color: kit.secondary),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoViewer extends StatelessWidget {
  const _PhotoViewer({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(context.l10n.messagesPhoto),
      ),
      body: InteractiveViewer(
        child: Center(
          child: Image.network(
            url,
            errorBuilder: (_, _, _) => Text(
              context.l10n.messagesPhotoFailed,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
    );
  }
}
