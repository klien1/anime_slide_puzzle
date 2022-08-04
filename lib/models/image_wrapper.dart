import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui' as ui;

class ImageWrapper {
  final int _width;
  final int _height;
  final Image _image;

  ImageWrapper._createDimension({
    required int height,
    required int width,
    required image,
  })  : _image = image,
        _height = height,
        _width = width;

  static Future<void> getImageInfo(Image curImage) async {
    final Image image = curImage;

    Completer<ui.Image> completer = Completer<ui.Image>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool _) {
          completer.complete(image.image);
        },
      ),
    );

    ui.Image info = await completer.future;

    ImageWrapper._createDimension(
      image: curImage,
      height: info.height,
      width: info.width,
    );

    info.dispose();
  }

  int get width {
    return _width;
  }

  int get height {
    return _height;
  }

  Image get image {
    return _image;
  }
}
