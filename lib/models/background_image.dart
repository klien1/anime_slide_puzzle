import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';

class BackgroundImage extends ChangeNotifier {
  BackgroundImage({required this.curImagePath});

  String curImagePath;

  void changeImage(String path) {
    curImagePath = path;
    notifyListeners();
  }

  SizedBox getCurrentBackgroundImage() {
    return SizedBox(
      key: UniqueKey(),
      width: double.infinity,
      height: double.infinity,
      child: DecoratedBox(
        key: UniqueKey(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(curImagePath),
            // source: https://wall.alphacoders.com/big.php?i=1143485
            // image: AssetImage('images/jujutsu_kaisen_background2.jpg'),
            // image: AssetImage('images/demon_slayer_background.jpg'),
            // source: https://wallpapersden.com/demon-slayer-4k-gaming-wallpaper/
            // image: AssetImage('images/spy-x-family-background2.jpg'),
            // source: https://wall.alphacoders.com/big.php?i=1227567
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
