import 'package:flutter/material.dart';
import 'package:anime_slide_puzzle/constants.dart';
import 'package:anime_slide_puzzle/models/image_wrapper.dart';

class PuzzleImageSelector extends ChangeNotifier {
  PuzzleImageSelector({List<String> pathList = imagePathList})
      : _pathList = imagePathList;

  final List<String> _pathList;
  bool _isLoadingImage = true;
  late List<ImageWrapper> _imageList = [];
  late ImageWrapper _curImage;
  bool _hasLoaded = false;

  void loadImages() async {
    if (_hasLoaded) return;
    _hasLoaded = true;
    try {
      for (String imagePath in _pathList) {
        ImageWrapper imageWrapper = await ImageWrapper.getImageInfo(imagePath);
        _imageList.add(imageWrapper);
      }
      _curImage = _imageList.first;
      _isLoadingImage = false;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  bool get isLoadingImage {
    return _isLoadingImage;
  }

  List<ImageWrapper> get imageList {
    if (isLoadingImage) {
      throw Exception('Cannot get image list. Images are still loading.');
    }
    return _imageList;
  }

  ImageWrapper get currentImage {
    if (isLoadingImage) {
      throw Exception('Cannot get currentImage. Images are still loading.');
    }
    return _curImage;
  }

  void changeImage(int index) {
    _curImage = _imageList[index];
    notifyListeners();
  }
}
