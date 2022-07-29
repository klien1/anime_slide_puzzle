import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui' as ui;

// Create new Future to get image info and returns Image dimensions
Future<ImageDimension> getImageDimension(Image curImage) async {
  final Image image = curImage;

  Completer<ui.Image> completer = Completer<ui.Image>();
  image.image
      .resolve(const ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo image, bool _) {
    completer.complete(image.image);
  }));

  ui.Image info = await completer.future;
  return ImageDimension(width: info.width, height: info.height);
}

class ImageDimension {
  final int _width;
  final int _height;

  ImageDimension({required width, required height})
      : _width = width,
        _height = height;

  int get width {
    return _width;
  }

  int get height {
    return _height;
  }
}
