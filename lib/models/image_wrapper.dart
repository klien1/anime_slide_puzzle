import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui' as ui;

class ImageWrapper {
  ImageWrapper._createDimension({
    required double height,
    required double width,
    required AssetImage assetImage,
    required String imagePath,
  })  : _assetImage = assetImage,
        _height = height,
        _width = width,
        _imagePath = imagePath;

  final double _width;
  final double _height;
  final AssetImage _assetImage;
  late final String _imagePath;

  static Future<ImageWrapper> getImageInfo(String imagePath) async {
    final Image image = Image.asset(imagePath);

    Completer<ui.Image> completer = Completer<ui.Image>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool _) {
          completer.complete(image.image);
        },
      ),
    );

    ui.Image info = await completer.future;

    ImageWrapper newImageWrapper = ImageWrapper._createDimension(
      assetImage: AssetImage(imagePath),
      height: info.height.toDouble(),
      width: info.width.toDouble(),
      imagePath: imagePath,
    );

    info.dispose();

    return newImageWrapper;
  }

  double get width {
    return _width;
  }

  double get height {
    return _height;
  }

  AssetImage get assetImage {
    return _assetImage;
  }

  String get imagePath {
    return _imagePath;
  }
}
