import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

import '../../api/api_client.dart';
import '../../api/models.dart';
import '../../config.dart';
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
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  Future<void> _attachPhoto() async {
    final photo = await widget._takePhoto(
      context,
      const PhotoPrompt(
        title: 'Photo for your clinic',
        hint: 'Take a clear photo in good light. It\'s sent with your message.',
      ),
    );
    if (photo == null || !mounted || _attachments.length >= maxMessagePhotos) {
      return;
    }
    setState(() => _attachments.add(photo));
  }

  @override
  Widget build(BuildContext context) {
    final messages = _messages;
    final canAttach =
        widget._cameraSupported && _attachments.length < maxMessagePhotos;
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
                padding: const EdgeInsets.fromLTRB(16, 8, 12, 96),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (widget._cameraSupported) ...[
                      IconButton(
                        key: const Key('message-attach'),
                        onPressed: _sending || !canAttach ? null : _attachPhoto,
                        tooltip: 'Add a photo',
                        color: context.kit.accentText,
                        style: IconButton.styleFrom(
                          minimumSize: const Size(46, 46),
                        ),
                        icon: const Icon(Icons.photo_camera_outlined),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Expanded(
                      child: TextField(
                        key: const Key('message-input'),
                        controller: _input,
                        minLines: 1,
                        maxLines: 5,
                        maxLength: 4000,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Message your clinic',
                          counterText: '',
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 13,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: context.kit.hairline,
                              width: 0.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: context.kit.hairline,
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: context.kit.accent,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      key: const Key('message-send'),
                      onPressed: _sending ? null : _send,
                      tooltip: 'Send',
                      style: IconButton.styleFrom(
                        backgroundColor: context.kit.accentText,
                        foregroundColor: context.kit.isDark
                            ? Colors.black
                            : Colors.white,
                        minimumSize: const Size(46, 46),
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
                        color: mine ? ShineColors.ink : palette.ink,
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
                  style: TextStyle(fontSize: 12, color: palette.muted),
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
      label: 'Open photo',
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => _PhotoViewer(url: photo.url)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            photo.url,
            key: Key('message-photo-${photo.id}'),
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: 120,
              height: 120,
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
        title: const Text('Photo'),
      ),
      body: InteractiveViewer(
        child: Center(
          child: Image.network(
            url,
            errorBuilder: (_, _, _) => const Text(
              'This photo didn\'t load. Please try again later.',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
    );
  }
}
