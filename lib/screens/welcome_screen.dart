import 'package:anime_slide_puzzle/components/circle_transition_button.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:anime_slide_puzzle/screens/image_selection_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:anime_slide_puzzle/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  static String id = 'welcome_screen';

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool isLoading = true;

  Future<void> loadingAssets() async {
    await precacheImage(
      const AssetImage(welcomeScreenImage),
      context,
    );

    if (!mounted) return;
    final AnimeThemeList animeThemeList = context.read<AnimeThemeList>();
    final int curIndex = animeThemeList.curIndex;

    if (!mounted) return;
    await precacheImage(
      AssetImage(
          animeThemeList.getAnimeThemeAtIndex(curIndex).backgroundImagePath),
      context,
    );

    if (!mounted) return;
    await precacheImage(
      AssetImage(animeThemeList
          .getAnimeThemeAtIndex(curIndex)
          .puzzleBackgroundImagePath),
      context,
    );

    setState(() => isLoading = false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadingAssets();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kWelcomeScreenScaffoldColor,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: (isLoading)
              ? const SpinKitPouringHourGlassRefined(
                  color: kSpinkitColor,
                  size: 100,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Anime Slide Puzzle',
                      style: kAnimeTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: screenHeight * .6),
                      width: double.infinity,
                      child: const Image(image: AssetImage(welcomeScreenImage)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const _ProjectGithubLink(),
                        CircleTransitionButton(
                          destinationScreen: const ImageSelectionScreen(),
                          buttonText: 'Let\'s get started',
                          buttonStyle: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              kWelcomeScreenCallToActionButtonBackgroundColor,
                            ),
                          ),
                          textStyle: const TextStyle(
                            color: kWelcomeScreenButtonTextColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
        ),
      ),
    );
  }
}

class _ProjectGithubLink extends StatelessWidget {
  const _ProjectGithubLink({Key? key}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    final Uri urlPath = Uri.parse(url);
    if (!await launchUrl(urlPath)) {
      throw 'Count not launch $urlPath';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
          backgroundColor: kWelcomeScreenButtonBackgroundColor),
      onPressed: () =>
          _launchUrl('https://github.com/klien1/anime_slide_puzzle'),
      icon: const Icon(
        FontAwesomeIcons.github,
        color: kWelcomeScreenButtonTextColor,
      ),
      label: const Text(
        'Github',
        style: TextStyle(color: kWelcomeScreenButtonTextColor),
      ),
    );
  }
}
