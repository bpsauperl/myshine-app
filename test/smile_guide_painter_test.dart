import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myshine/screens/simulation/smile_guide_painter.dart';

void main() {
  const frame = Size(300, 400);

  test('the lips box sits inside the lower half of the face oval', () {
    final face = SmileGuidePainter.faceOvalIn(frame);
    final lips = SmileGuidePainter.lipsBoxIn(frame);

    expect(face.center.dx, frame.width / 2);
    expect(lips.center.dx, face.center.dx);
    expect(
      face.contains(lips.topLeft) && face.contains(lips.bottomRight),
      isTrue,
    );
    expect(lips.center.dy, greaterThan(face.center.dy));
    expect(lips.width, lessThan(face.width));
  });

  test('the outline is about 35% white', () {
    const painter = SmileGuidePainter();
    expect(painter.guideColor.a, closeTo(0.35, 0.01));
    expect(painter.guideColor.r, 1);
  });

  test('repaints only when its look changes', () {
    const painter = SmileGuidePainter();
    expect(painter.shouldRepaint(const SmileGuidePainter()), isFalse);
    expect(
      painter.shouldRepaint(const SmileGuidePainter(opacity: 0.5)),
      isTrue,
    );
  });

  test('paints an oval and a rounded box', () {
    final recorder = ui.PictureRecorder();
    final canvas = _RecordingCanvas(Canvas(recorder));
    const SmileGuidePainter().paint(canvas, frame);
    recorder.endRecording();

    expect(canvas.ovals.single, SmileGuidePainter.faceOvalIn(frame));
    expect(canvas.rrects.single.outerRect, SmileGuidePainter.lipsBoxIn(frame));
  });

  test('draws nothing in an empty frame', () {
    final recorder = ui.PictureRecorder();
    final canvas = _RecordingCanvas(Canvas(recorder));
    const SmileGuidePainter().paint(canvas, Size.zero);
    recorder.endRecording();
    expect(canvas.ovals, isEmpty);
  });

  testWidgets('shows over the camera frame', (tester) async {
    await tester.pumpWidget(
      const Center(
        child: SizedBox(
          width: 300,
          height: 400,
          child: CustomPaint(painter: SmileGuidePainter()),
        ),
      ),
    );
    expect(
      find.byWidgetPredicate(
        (w) => w is CustomPaint && w.painter is SmileGuidePainter,
      ),
      findsOneWidget,
    );
  });
}

/// Passes through to a real canvas and remembers the shapes drawn.
class _RecordingCanvas implements Canvas {
  _RecordingCanvas(this._inner);

  final Canvas _inner;
  final List<Rect> ovals = [];
  final List<RRect> rrects = [];

  @override
  void drawOval(Rect rect, Paint paint) {
    ovals.add(rect);
    _inner.drawOval(rect, paint);
  }

  @override
  void drawRRect(RRect rrect, Paint paint) {
    rrects.add(rrect);
    _inner.drawRRect(rrect, paint);
  }

  @override
  void drawLine(Offset p1, Offset p2, Paint paint) =>
      _inner.drawLine(p1, p2, paint);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
