import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../api/models.dart';
import '../../theme.dart';
import '../../util/captured_file.dart';

/// What the camera screen asks for: a title and a line of guidance.
class PhotoPrompt {
  const PhotoPrompt({required this.title, required this.hint});

  final String title;
  final String hint;
}

/// Opens the camera for [prompt]; returns the photo, or null on back.
typedef PhotoTaker = Future<PhotoUpload?> Function(
  BuildContext context,
  PhotoPrompt prompt,
);

/// The app's camera, as the check-in card and Messages use it. The web
/// preview (`tool/preview_main.dart`) swaps in sample photos.
abstract final class PhotoCapture {
  /// False on web: the camera works only in the phone app.
  static bool supported = !kIsWeb;

  static PhotoTaker take = PhotoCameraScreen.take;
}

/// Takes one photo for a check-in or a message and returns it as a
/// [PhotoUpload] (or null when the patient goes back). Nothing is uploaded
/// until the patient sends the check-in or message.
class PhotoCameraScreen extends StatefulWidget {
  const PhotoCameraScreen({super.key, required this.prompt});

  final PhotoPrompt prompt;

  /// Opens the camera and waits for a photo.
  static Future<PhotoUpload?> take(BuildContext context, PhotoPrompt prompt) =>
      Navigator.of(context).push<PhotoUpload>(
        MaterialPageRoute(builder: (_) => PhotoCameraScreen(prompt: prompt)),
      );

  @override
  State<PhotoCameraScreen> createState() => _PhotoCameraScreenState();
}

enum _CameraStatus { starting, ready, unavailable, denied }

class _PhotoCameraScreenState extends State<PhotoCameraScreen>
    with WidgetsBindingObserver {
  List<CameraDescription> _cameras = const [];
  CameraDescription? _camera;
  CameraController? _controller;
  _CameraStatus _status = _CameraStatus.starting;
  bool _capturing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _controller = null;
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _startCamera();
    }
  }

  Future<void> _startCamera() async {
    setState(() => _status = _CameraStatus.starting);
    try {
      if (_cameras.isEmpty) {
        _cameras = await availableCameras();
      }
      if (_cameras.isEmpty) {
        setState(() => _status = _CameraStatus.unavailable);
        return;
      }
      // The front camera by default: easiest for a photo of your own teeth.
      final camera =
          _camera ??
          _cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.front,
            orElse: () => _cameras.first,
          );
      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _camera = camera;
        _controller = controller;
        _status = _CameraStatus.ready;
      });
    } on CameraException catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = e.code.contains('Denied') || e.code.contains('denied')
            ? _CameraStatus.denied
            : _CameraStatus.unavailable;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _status = _CameraStatus.unavailable);
      }
    }
  }

  Future<void> _switchCamera() async {
    final current = _camera;
    if (current == null || _cameras.length < 2) {
      return;
    }
    final next = _cameras.firstWhere(
      (c) => c.lensDirection != current.lensDirection,
      orElse: () => current,
    );
    final old = _controller;
    setState(() {
      _camera = next;
      _controller = null;
    });
    await old?.dispose();
    await _startCamera();
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || _capturing) {
      return;
    }
    setState(() => _capturing = true);
    try {
      final file = await controller.takePicture();
      final bytes = await readAndDeleteCapture(file);
      if (!mounted) {
        return;
      }
      final name = file.name.contains('.') ? file.name : '${file.name}.jpg';
      Navigator.of(context).pop(PhotoUpload(bytes: bytes, filename: name));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('That didn\'t work. Please try again.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _capturing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ready = _status == _CameraStatus.ready && _controller != null;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.prompt.title),
        actions: [
          if (ready && _cameras.length > 1)
            IconButton(
              tooltip: 'Switch camera',
              onPressed: _capturing ? null : _switchCamera,
              icon: const Icon(Icons.cameraswitch_rounded),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(kCardRadius),
                      child: ready
                          ? _CoverPreview(controller: _controller!)
                          : _placeholder(),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Text(
                widget.prompt.hint,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: ready
                  ? _ShutterButton(busy: _capturing, onPressed: _capture)
                  : const SizedBox(height: 76),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    if (_status == _CameraStatus.starting) {
      return const ColoredBox(
        color: Color(0xFF1C1C1E),
        child: Center(
          child: CircularProgressIndicator(color: ShineColors.teal),
        ),
      );
    }
    return ColoredBox(
      color: const Color(0xFF1C1C1E),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _status == _CameraStatus.denied
                ? 'Allow camera access for myShine in Settings to add a photo.'
                : 'Camera unavailable here',
            key: const Key('camera-unavailable'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// The camera preview filling the frame (cropped, not stretched).
class _CoverPreview extends StatelessWidget {
  const _CoverPreview({required this.controller});

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    final previewSize = controller.value.previewSize;
    // previewSize is landscape; the phone is held upright.
    final width = previewSize?.height ?? 3;
    final height = previewSize?.width ?? 4;
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: width,
          height: height,
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}

class _ShutterButton extends StatelessWidget {
  const _ShutterButton({required this.busy, required this.onPressed});

  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Take photo',
      child: GestureDetector(
        onTap: busy ? null : onPressed,
        child: Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
          ),
          padding: const EdgeInsets.all(5),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: busy ? Colors.white54 : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
