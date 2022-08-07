// const List<String> imagePathList = [
//   'images/demon_slayer1.jpg',
//   'images/jujutsu_kaisen.jpg',
//   'images/spy-x-family.webp',
// ];

// const List<String> logoImageList = [
//   'images/demon_slayer_logo.png',
//   'images/jujutsu_kaisen_logo.jpg',
//   'images/Spy_×_Family_logo.png',
// ];

// const List<String> backgroundImageList = [
//   'images/demon_slayer_background.jpg',
//   'images/jujutsu_kaisen_background2.png',
//   'images/spy-x-family-background_no_logo.png',
// ];

// const Map<String, String> animeImage
const Map<String, Map<String, String>> animeImageList = {
  'demon_slayer': {
    'logo': 'images/demon_slayer_logo.png',
    'puzzle': 'images/demon_slayer1.jpg',
    'background': 'images/demon_slayer_background.jpg'
  },
  'jujutsu_kaisen': {
    'logo': 'images/jujutsu_kaisen_logo.jpg',
    'puzzle': 'images/jujutsu_kaisen.jpg',
    'background': 'images/jujutsu_kaisen_background2.png'
  },
  'spy_x_family': {
    'logo': 'images/Spy_×_Family_logo.png',
    'puzzle': 'images/spy-x-family.webp',
    'background': 'images/spy-x-family-background_no_logo.png'
  },
};

// source: https://wall.alphacoders.com/big.php?i=1143485
// image: AssetImage('images/jujutsu_kaisen_background2.jpg'),
// image: AssetImage('images/demon_slayer_background.jpg'),
// source: https://wallpapersden.com/demon-slayer-4k-gaming-wallpaper/
// image: AssetImage('images/spy-x-family-background2.jpg'),
// source: https://wall.alphacoders.com/big.php?i=1227567

const Duration defaultTileSpeed = Duration(milliseconds: 100);
