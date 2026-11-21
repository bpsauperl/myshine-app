import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../l10n/l10n.dart';

/// One scene of the opening film: a short silent clip, its first frame as a
/// still, and the line that goes with it.
class IntroScene {
  const IntroScene(this.name, this.caption);

  final String name;
  final String Function(AppLocalizations l10n) caption;

  String get video => 'assets/video/intro-$name.mp4';
  String get poster => 'assets/video/intro-$name.jpg';
}

/// The patient's way through Shine, in SmileLabs' own clips: the dentist, the
/// scan, the plan, wearing the aligner, the aligner.
final List<IntroScene> kIntroScenes = [
  IntroScene('consult', (l) => l.introConsult),
  IntroScene('scan', (l) => l.introScan),
  IntroScene('plan', (l) => l.introPlan),
  IntroScene('wear', (l) => l.introWear),
  IntroScene('aligner', (l) => l.introAligner),
];

/// The opening film, full screen, like a story: thin bars at the top show
/// where you are; tap the right side for the next scene and the left side for
/// the one before, hold to pause. Muted and looping. When video can't play,
/// or the phone asks for less motion, the scenes are still photos you tap
/// through.
class IntroStory extends StatefulWidget {
  const IntroStory({super.key, this.onScene, this.topInset = 0});

  /// Tells the welcome screen which scene shows, for its caption.
  final ValueChanged<int>? onScene;

  /// Room for the bars under the status bar.
  final double topInset;

  @override
  State<IntroStory> createState() => IntroStoryState();
}

class IntroStoryState extends State<IntroStory> {
  final Map<int, VideoPlayerController> _players = {};
  int _scene = 0;
  bool _videoWorks = true;
  bool _paused = false;
  bool _held = false;

  /// True once the current clip has really started: a clip seen before still
  /// reports its old end for a moment after it is rewound.
  bool _started = false;

  int get scene => _scene;

  bool get paused => _paused;

  @override
  void initState() {
    super.initState();
    _prepare(0).then((ok) {
      if (ok && mounted) {
        _play(0);
        _prepare(1);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Less motion asked for: no film, the stills only.
    if (MediaQuery.disableAnimationsOf(context) && _videoWorks) {
      _videoWorks = false;
      for (final player in _players.values) {
        player.pause();
      }
    }
  }

  @override
  void dispose() {
    for (final player in _players.values) {
      player.removeListener(_tick);
      unawaited(player.dispose().catchError((_) {}));
    }
    super.dispose();
  }

  /// Loads a scene's clip; false when video can't play here.
  Future<bool> _prepare(int index) async {
    if (!_videoWorks || _players.containsKey(index)) {
      return _videoWorks;
    }
    final player = VideoPlayerController.asset(
      kIntroScenes[index].video,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _players[index] = player;
    try {
      await player.initialize();
      await player.setVolume(0);
      return true;
    } catch (_) {
      _players.remove(index);
      if (mounted) {
        setState(() => _videoWorks = false);
      }
      return false;
    }
  }

  void _play(int index) {
    final player = _players[index];
    if (player == null || !mounted) {
      return;
    }
    _started = false;
    player
      ..removeListener(_tick)
      ..addListener(_tick);
    unawaited(player.seekTo(Duration.zero));
    if (!_paused) {
      unawaited(player.play());
    }
    setState(() {});
  }

  /// At the end of a clip, the next scene starts.
  void _tick() {
    final player = _players[_scene];
    if (player == null || !player.value.isInitialized) {
      return;
    }
    final value = player.value;
    if (!_started && value.isPlaying && value.position < value.duration - const Duration(milliseconds: 600)) {
      _started = true;
    }
    if (_started &&
        value.duration > Duration.zero &&
        value.position >= value.duration - const Duration(milliseconds: 80) &&
        !value.isPlaying) {
      go(_scene + 1);
    } else if (mounted) {
      setState(() {});
    }
  }

  /// Shows a scene (wrapping round at the ends).
  Future<void> go(int index) async {
    final next = index % kIntroScenes.length;
    _players[_scene]?.removeListener(_tick);
    unawaited(_players[_scene]?.pause());
    setState(() => _scene = next < 0 ? kIntroScenes.length - 1 : next);
    widget.onScene?.call(_scene);
    if (await _prepare(_scene)) {
      _play(_scene);
      unawaited(_prepare((_scene + 1) % kIntroScenes.length));
    }
  }

  void togglePause() {
    setState(() => _paused = !_paused);
    final player = _players[_scene];
    if (player != null) {
      _paused ? player.pause() : player.play();
    }
  }

  void _hold(bool held) {
    if (_paused) {
      return;
    }
    setState(() => _held = held);
    final player = _players[_scene];
    if (player != null) {
      held ? player.pause() : player.play();
    }
  }

  /// How far each bar is filled: 1 for scenes seen, the clip's progress for this one.
  double _fill(int index) {
    if (index < _scene) {
      return 1;
    }
    if (index > _scene) {
      return 0;
    }
    final player = _players[_scene];
    if (player == null || !player.value.isInitialized || player.value.duration == Duration.zero) {
      return _videoWorks ? 0 : 1;
    }
    return (player.value.position.inMilliseconds / player.value.duration.inMilliseconds).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final player = _players[_scene];
    final playing = _videoWorks && player != null && player.value.isInitialized;
    return Semantics(
      container: true,
      label: '${l10n.introScene(_scene + 1, kIntroScenes.length)}: ${kIntroScenes[_scene].caption(l10n)}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (details) {
          final width = context.size?.width ?? 1;
          go(details.localPosition.dx < width * 0.3 ? _scene - 1 : _scene + 1);
        },
        onLongPressStart: (_) => _hold(true),
        onLongPressEnd: (_) => _hold(false),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // The still under the film: shows while a clip loads, and instead of it.
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              child: Image.asset(
                kIntroScenes[_scene].poster,
                key: ValueKey('poster-$_scene'),
                fit: BoxFit.cover,
                gaplessPlayback: true,
              ),
            ),
            if (playing)
              // Sized to cover the screen and clipped (no scaling transform: the web's
              // video element doesn't follow one).
              LayoutBuilder(
                key: ValueKey('film-$_scene'),
                builder: (context, box) {
                  final video = player.value.size;
                  final scale = [box.maxWidth / video.width, box.maxHeight / video.height].reduce((a, b) => a > b ? a : b);
                  final width = video.width * scale;
                  final height = video.height * scale;
                  return ClipRect(
                    child: OverflowBox(
                      maxWidth: width,
                      maxHeight: height,
                      child: SizedBox(width: width, height: height, child: VideoPlayer(player)),
                    ),
                  );
                },
              ),
            // A soft shade at the top and bottom so the white bars and words read on any frame.
            const IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x66000000), Color(0x00000000), Color(0x00000000), Color(0xB3000000)],
                    stops: [0, 0.18, 0.45, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              top: widget.topInset + 10,
              child: IgnorePointer(
                child: Row(
                  children: [
                    for (var i = 0; i < kIntroScenes.length; i++) ...[
                      if (i > 0) const SizedBox(width: 4),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: SizedBox(
                            height: 3,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                const ColoredBox(color: Color(0x59FFFFFF)),
                                FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: _fill(i),
                                  child: const ColoredBox(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (_held)
              const IgnorePointer(child: ColoredBox(color: Color(0x14000000))),
          ],
        ),
      ),
    );
  }
}
