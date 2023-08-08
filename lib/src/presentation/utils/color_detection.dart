import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class ColorDetection {
  final GlobalKey? currentKey;
  final StreamController<Color>? stateController;
  final GlobalKey? paintKey;

  img.Image? photo;

  ColorDetection({
    required this.currentKey,
    required this.stateController,
    required this.paintKey,
  });

  Future<dynamic> searchPixel(Offset globalPosition) async {
    if (photo == null) {
      await loadSnapshotBytes();
    }
    return _calculatePixel(globalPosition);
  }

  _calculatePixel(Offset globalPosition) {
    RenderBox box = currentKey!.currentContext!.findRenderObject() as RenderBox;
    Offset localPosition = box.globalToLocal(globalPosition);

    double px = localPosition.dx;
    double py = localPosition.dy;

    img.Pixel pixel32 = photo!.getPixelSafe(px.toInt(), py.toInt());
    final Color color = Color.fromARGB(255, pixel32.r.toInt(), pixel32.g.toInt(), pixel32.b.toInt());

    stateController!.add(color);
    return color;
  }

  Future<void> loadSnapshotBytes() async {
    RenderRepaintBoundary? boxPaint = paintKey!.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    ui.Image capture = await boxPaint!.toImage();
    ByteData? imageBytes = await capture.toByteData(format: ui.ImageByteFormat.png);
    setImageBytes(imageBytes!);
    capture.dispose();
  }

  void setImageBytes(ByteData imageBytes) {
    Uint8List values = imageBytes.buffer.asUint8List();
    photo = null;
    photo = img.decodeImage(values);
  }
}
