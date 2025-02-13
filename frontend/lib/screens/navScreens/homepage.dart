import 'package:flutter/material.dart';
import '../../widgets/advanced_drawing_canvas.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Drawing Game',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnimatedGameModeButton(
                  context,
                  'Offline Mode',
                  'Challenge yourself against AI',
                  Icons.person,
                  '/offline-game',
                  0,
                ),
                const SizedBox(height: 16),
                _buildAnimatedGameModeButton(
                  context,
                  'Online Mode',
                  'Compete with players worldwide',
                  Icons.people,
                  '/online-game',
                  1,
                ),
                const SizedBox(height: 16),
                _buildAnimatedGameModeButton(
                  context,
                  'Multiplayer Room',
                  'Create or join custom rooms',
                  Icons.groups,
                  '/multiplayer',
                  2,
                ),
                const SizedBox(height: 32),
                _buildBottomButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedGameModeButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String route,
    int index,
  ) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 100)),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, route),
          style: AppTheme.gameButtonStyle,
          child: ListTile(
            leading: Icon(icon, color: Colors.white, size: 32),
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconButton(
              context, 'Leaderboard', Icons.leaderboard, '/leaderboard'),
          _buildIconButton(context, 'Profile', Icons.person, '/profile'),
          _buildIconButton(context, 'Settings', Icons.settings, '/settings'),
        ],
      ),
    );
  }

  Widget _buildIconButton(
    BuildContext context,
    String label,
    IconData icon,
    String route,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: () => Navigator.pushNamed(context, route),
          iconSize: 32,
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
