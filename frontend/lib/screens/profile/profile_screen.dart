import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Map<String, dynamic> _userStats = {
    'username': 'Player123',
    'level': 15,
    'totalScore': 12500,
    'gamesPlayed': 150,
    'wins': 85,
    'winRate': '56.7%',
    'achievements': [
      {'name': 'First Win', 'description': 'Win your first game', 'achieved': true},
      {'name': 'Pro Artist', 'description': 'Win 50 games', 'achieved': true},
      {'name': 'Master Drawer', 'description': 'Win 100 games', 'achieved': false},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement edit profile
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildStatsSection(),
            _buildAchievementsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 16),
          Text(
            _userStats['username'],
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            'Level ${_userStats['level']}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildStatRow('Total Score', _userStats['totalScore'].toString()),
          _buildStatRow('Games Played', _userStats['gamesPlayed'].toString()),
          _buildStatRow('Wins', _userStats['wins'].toString()),
          _buildStatRow('Win Rate', _userStats['winRate']),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Achievements',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ..._userStats['achievements'].map<Widget>((achievement) {
            return ListTile(
              leading: Icon(
                achievement['achieved'] ? Icons.star : Icons.star_border,
                color: achievement['achieved'] ? Colors.amber : Colors.grey,
              ),
              title: Text(achievement['name']),
              subtitle: Text(achievement['description']),
            );
          }).toList(),
        ],
      ),
    );
  }
}
