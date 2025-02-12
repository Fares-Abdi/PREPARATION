import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hanini_frontend/localization/app_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hanini_frontend/models/colors.dart';

Widget Sidebar(BuildContext context, AppLocalizations appLocalizations) {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> checkIfUserIsAdmin() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        return data['isAdmin'] ?? false;
      }
    }
    return false;
  }

  Future<void> handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({
          'isConnected': false,
          'lastSignIn': DateTime.now(),
        });
      }

      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      await prefs.setBool('isLoggedIn', false);
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Logout Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  return Drawer(
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
          decoration: BoxDecoration(
            gradient: AppColors.mainGradient,
          ),
          child: Row(
            children: [
              Text(
                appLocalizations.menu,
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<bool>(
            future: checkIfUserIsAdmin(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final isAdmin = snapshot.data ?? false;

              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  if (isAdmin)
                    _buildSidebarItem(
                      context,
                      icon: Icons.admin_panel_settings,
                      // iconColor: AppColors.mainColor,
                      title: 'Add Admin',
                      onTap: () => Navigator.pushNamed(context, '/add-admin'),
                    )
                  else
                    _buildSidebarItem(
                      context,
                      icon: Icons.settings,
                      title: appLocalizations.settings,
                      onTap: () => Navigator.pushNamed(context, '/settings'),
                    ),
                  _buildSidebarItem(
                    context,
                    icon: Icons.logout,
                    title: appLocalizations.logout,
                    onTap: () => _showLogoutDialog(context, handleLogout),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ),
  );
}

Widget _buildSidebarItem(
  BuildContext context, {
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  Color iconColor = AppColors.secondaryColor, // Default icon color
  double iconSize = 24.0,             // Default icon size
}) {
  return ListTile(
    leading: Icon(
      icon,
      color: iconColor, // Use the customizable icon color
      size: iconSize, // Use the customizable icon size
    ),
    title: Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    hoverColor: Colors.grey.shade100,
  );
}

Future<void> _showLogoutDialog(
    BuildContext context, Future<void> Function() onLogout) async {
  final localizations = AppLocalizations.of(context);
  if (localizations == null) return;

  final shouldLogout = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          localizations.logout,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          localizations.areYouSureYouWantToLogout,
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(localizations.cancel,
                style: GoogleFonts.poppins(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(localizations.logout,
                style: GoogleFonts.poppins(color: Colors.blue)),
          ),
        ],
      );
    },
  );

  if (shouldLogout == true) {
    await onLogout();
  }
}
