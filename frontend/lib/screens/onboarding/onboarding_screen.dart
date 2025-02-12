import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hanini_frontend/localization/app_localization.dart';
import 'package:hanini_frontend/main.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Method to handle page change
  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  // Language change logic
  void _changeLanguage(String languageCode) {
    Locale newLocale;
    switch (languageCode) {
      case 'ar':
        newLocale = Locale('ar', '');
        break;
      case 'fr':
        newLocale = Locale('fr', '');
        break;
      default:
        newLocale = Locale('en', '');
    }
    MyApp.of(context)?.changeLanguage(newLocale);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      return Center(child: CircularProgressIndicator());
    }

    // Pages data with mixed content
    final pages = [
      {
        "animationPath": 'assets/animation/animation1.json',
        "title": localizations.onboardingTitle1,
        "description": localizations.onboardingDescription1,
      },
      {
        "imagePath": 'assets/images/onboarding2.png',
        "title": localizations.onboardingTitle2,
        "description": localizations.onboardingDescription2,
      },
      {
        "imagePath": 'assets/images/onboarding3_b.png',
        "title": localizations.onboardingTitle3,
        "description": localizations.onboardingDescription3,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          _buildLanguageDropdown(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: pages.length,
              itemBuilder: (context, index) {
                final page = pages[index];
                return _buildPage(
                  animationPath: page["animationPath"],
                  imagePath: page["imagePath"],
                  title: page["title"]!,
                  description: page["description"]!,
                );
              },
            ),
          ),
          _buildIndicators(pages.length),
          SizedBox(height: 20),
          _buildNextButton(context, localizations),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  // Build individual page with either Lottie animation or static image
  Widget _buildPage({
    String? animationPath,
    String? imagePath,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (animationPath != null)
            Lottie.asset(animationPath, fit: BoxFit.cover, height: 300, repeat: true)
          else if (imagePath != null)
            Image.asset(imagePath, fit: BoxFit.cover, height: 300),
          SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Build the indicators below the pages
  Widget _buildIndicators(int pageCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          height: 12,
          width: _currentPage == index ? 25 : 12,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.purple : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

  // Build the next button for navigation
  Widget _buildNextButton(
      BuildContext context, AppLocalizations localizations) {
    return ElevatedButton(
      onPressed: () {
        if (_currentPage == 2) {
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        _currentPage == 2 ? localizations.getStarted : localizations.next,
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
      ),
    );
  }

  // Build the language selection dropdown with icons
  Widget _buildLanguageDropdown() {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      return Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: PopupMenuButton<String>(
        onSelected: _changeLanguage,
        icon: Icon(Icons.language, color: Colors.black, size: 28),
        itemBuilder: (BuildContext context) {
          return [
            _buildLanguageMenuItem(
                'en', localizations.englishLanguageName, 'assets/images/sen.png'),
            _buildLanguageMenuItem(
                'ar', localizations.arabicLanguageName, 'assets/images/sarab.png'),
            _buildLanguageMenuItem(
                'fr', localizations.frenchLanguageName, 'assets/images/sfr.png'),
          ];
        },
      ),
    );
  }

  // Helper method to build individual language menu items with flags
  PopupMenuItem<String> _buildLanguageMenuItem(
      String languageCode, String languageName, String flagPath) {
    return PopupMenuItem<String>(
      value: languageCode,
      child: Row(
        children: [
          Image.asset(flagPath, width: 22),
          SizedBox(width: 10),
          Text(languageName),
        ],
      ),
    );
  }
}
