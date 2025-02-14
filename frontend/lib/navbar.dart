import 'package:flutter/material.dart';
import 'package:hanini_frontend/screens/navScreens/chatpage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hanini_frontend/screens/Profiles/SimpleUserProfile.dart';
import 'package:hanini_frontend/screens/navScreens/searchpage.dart';
import 'package:hanini_frontend/screens/navScreens/favoritespage.dart';
import 'package:hanini_frontend/screens/navScreens/sidebar.dart';
import 'package:hanini_frontend/screens/navScreens/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hanini_frontend/localization/app_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hanini_frontend/screens/navScreens/notificationspage.dart';
import 'models/colors.dart';
import 'package:hanini_frontend/main.dart'; // Import MyApp class
import 'screens/scribble_lobby_screen.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final AppLocalizations appLocalizations;

  const CustomNavBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.appLocalizations,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      backgroundColor: Colors.deepPurple[50],
      surfaceTintColor: Colors.deepPurple[100],
      destinations: [
        _buildDestination(
            icon: Iconsax.home,
            label: appLocalizations.home,
            isSelected: selectedIndex == 0),
        _buildDestination(
            icon: Iconsax.search_normal,
            label: appLocalizations.search,
            isSelected: selectedIndex == 1),
        _buildDestination(
            icon: Iconsax.save_2,
            label: appLocalizations.favorites,
            isSelected: selectedIndex == 2),
        _buildDestination(
            icon: Iconsax.message,
            label: "Chat",
            isSelected: selectedIndex == 3),
        _buildDestination(
            icon: Icons.games,
            label: 'Scribble',
            isSelected: selectedIndex == 4),
        _buildDestination(
            icon: Iconsax.user,
            label: appLocalizations.profile,
            isSelected: selectedIndex == 5),
      ],
    );
  }

  NavigationDestination _buildDestination({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return NavigationDestination(
      icon: Icon(
        icon,
        color: isSelected ? Colors.deepPurple : Colors.grey,
      ),
      label: label,
      selectedIcon: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.purple, Colors.deepPurple],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}

class NavbarPage extends StatefulWidget {
  final int initialIndex;
  final String? serviceName;
  final String? preSelectedWorkDomain;

  const NavbarPage({
    Key? key,
    required this.initialIndex,
    this.serviceName,
    this.preSelectedWorkDomain,
  }) : super(key: key);

  @override
  State<NavbarPage> createState() => _NavbarPageState();
}

class _NavbarPageState extends State<NavbarPage> {
  late int selectedIndex;
  String? serviceName;
  List<Widget> screens = [];
  bool isLoading = true;
  String currentLanguage = 'en';
  String? _currentPreSelectedWorkDomain;

  @override
  void initState() {
    super.initState();
    _loadUserLanguage();
    selectedIndex = widget.initialIndex;
    _currentPreSelectedWorkDomain = widget.preSelectedWorkDomain;
    _initializeScreens();
  }

  Future<void> _initializeScreens() async {
    try {
      setState(() {
        screens = [
          HomePage(),
          SearchPage(),
          FavoritesPage(),
          ChatPage(), // Add ChatPage here
          ScribbleLobbyScreen(), // Add Scribble Game here
          SimpleUserProfile(),
        ];
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onDestinationSelected(int index) {
    if (selectedIndex != index) {
      setState(() {
        selectedIndex = index;
        // Reset preSelectedWorkDomain when switching away from search page
        if (_currentPreSelectedWorkDomain != null) {
          _currentPreSelectedWorkDomain = null;
          _initializeScreens();
        }
      });
    }
  }

  Future<void> _loadUserLanguage() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          final savedLanguage = data['language'] as String?;
          if (savedLanguage != null) {
            setState(() {
              currentLanguage = savedLanguage;
              _updateAppLanguage(savedLanguage);
            });
          }
        }
      }
    } catch (e) {
      print('Error loading user language: $e');
    }
  }

  Future<void> _updateLanguage(String languageCode) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // First update Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'language': languageCode,
        });

        // Then update the locale and rebuild UI
        setState(() {
          currentLanguage = languageCode;
          // Update the app's locale
          Locale newLocale;
          switch (languageCode) {
            case 'ar':
              newLocale = const Locale('ar', '');
              break;
            case 'fr':
              newLocale = const Locale('fr', '');
              break;
            default:
              newLocale = const Locale('en', '');
          }

          // Force rebuild with new locale
          MyApp.of(context)?.changeLanguage(newLocale);
        });
      }
    } catch (e) {
      print('Error updating language: $e');
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : PopScope(
            canPop: false,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(64.0),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.mainGradient,
                  ),
                  child: AppBar(
                    title: Text(
                      appLocalizations.appTitle,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    actions: [
                      _buildNotificationBell(),
                      _buildLanguageDropdown(),
                    ],
                  ),
                ),
              ),
              drawer: Sidebar(context, appLocalizations),
              body: screens[selectedIndex],
              bottomNavigationBar: CustomNavBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: _onDestinationSelected,
                appLocalizations: appLocalizations,
              ),
            ),
          );
  }

  Widget _buildLanguageDropdown() {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      return const Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: PopupMenuButton<String>(
        onSelected: _updateLanguage,
        icon: const Icon(Icons.language, color: Colors.white, size: 28),
        itemBuilder: (BuildContext context) {
          return [
            _buildLanguageMenuItem('en', localizations.englishLanguageName,
                'assets/images/sen.png'),
            _buildLanguageMenuItem('ar', localizations.arabicLanguageName,
                'assets/images/sarab.png'),
            _buildLanguageMenuItem('fr', localizations.frenchLanguageName,
                'assets/images/sfr.png'),
          ];
        },
      ),
    );
  }

  PopupMenuItem<String> _buildLanguageMenuItem(
      String languageCode, String languageName, String flagPath) {
    return PopupMenuItem<String>(
      value: languageCode,
      child: Row(
        children: [
          Image.asset(flagPath, width: 22),
          const SizedBox(width: 10),
          Text(languageName),
        ],
      ),
    );
  }

  void _updateAppLanguage(String languageCode) {
    Locale newLocale;
    switch (languageCode) {
      case 'ar':
        newLocale = const Locale('ar', '');
        break;
      case 'fr':
        newLocale = const Locale('fr', '');
        break;
      default:
        newLocale = const Locale('en', '');
    }
    MyApp.of(context)?.changeLanguage(newLocale);
  }

  Widget _buildNotificationBell() {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    NotificationsPage(userId: _auth.currentUser?.uid ?? ''),
              ),
            );
          },
        ),
      ],
    );
  }
}
