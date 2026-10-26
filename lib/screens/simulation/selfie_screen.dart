import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';
import 'preview_screen.dart';
import 'sample_face.dart';
import 'smile_guide_painter.dart';

/// A guided front-camera selfie. The photo never leaves the phone.
class SelfieScreen extends StatefulWidget {
  const SelfieScreen({super.key, this.cameraSupported = !kIsWeb});

  /// False on web: the camera isn't used there, a sample illustration is shown.
  final bool cameraSupported;

  @override
  State<SelfieScreen> createState() => _SelfieScreenState();
}

enum _CameraStatus { starting, ready, unavailable, denied }

class _SelfieScreenState extends State<SelfieScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  _CameraStatus _status = _CameraStatus.starting;
  bool _capturing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.cameraSupported) {
      _startCamera();
    } else {
      _status = _CameraStatus.unavailable;
    }
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
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _status = _CameraStatus.unavailable);
        return;
      }
      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        front,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
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

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || _capturing) {
      return;
    }
    setState(() => _capturing = true);
    try {
      final file = await controller.takePicture();
      final bytes = await file.readAsBytes();
      if (!mounted) {
        return;
      }
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              PreviewScreen(photo: Image.memory(bytes, fit: BoxFit.cover)),
        ),
      );
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

  void _showSample() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            const PreviewScreen(photo: SampleFace(), isSample: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ready = _status == _CameraStatus.ready && _controller != null;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Smile photo'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AspectRatio(
                    aspectRatio: SmileGuidePainter.frameAspectRatio,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(kCardRadius),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (ready)
                            _CoverPreview(controller: _controller!)
                          else
                            _placeholder(),
                          const IgnorePointer(
                            child: CustomPaint(painter: SmileGuidePainter()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Text(
                ready
                    ? 'Fit your face in the oval and smile, so your teeth sit in the box.'
                    : 'The photo stays on your phone. Nothing is uploaded.',
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
                  : _status == _CameraStatus.starting
                  ? const SizedBox(height: 76)
                  : FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: ShineColors.ink,
                      ),
                      onPressed: _showSample,
                      child: const Text('See a sample preview'),
                    ),
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
    final denied = _status == _CameraStatus.denied;
    return Stack(
      fit: StackFit.expand,
      children: [
        const Opacity(opacity: 0.55, child: SampleFace()),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              denied
                  ? 'Allow camera access for myShine in Settings to take your photo.'
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
      ],
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
