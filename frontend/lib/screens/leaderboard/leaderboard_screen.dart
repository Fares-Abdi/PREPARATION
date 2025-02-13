import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final List<Map<String, dynamic>> _leaderboardData = [
    {'rank': 1, 'name': 'John Doe', 'score': 2500, 'wins': 42},
    {'rank': 2, 'name': 'Jane Smith', 'score': 2350, 'wins': 38},
    {'rank': 3, 'name': 'Mike Johnson', 'score': 2200, 'wins': 35},
    // Add more dummy data as needed
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Leaderboard'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Global'),
              Tab(text: 'Friends'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLeaderboardList(),
            _buildFriendsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardList() {
    return ListView.builder(
      itemCount: _leaderboardData.length,
      itemBuilder: (context, index) {
        final player = _leaderboardData[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Text('${player['rank']}'),
              backgroundColor: _getRankColor(player['rank']),
            ),
            title: Text(player['name']),
            subtitle: Text('Wins: ${player['wins']}'),
            trailing: Text(
              'Score: ${player['score']}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFriendsList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.people_outline, size: 48),
          SizedBox(height: 16),
          Text('Add friends to see their rankings!'),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber; // Gold
      case 2:
        return Colors.grey[300]!; // Silver
      case 3:
        return Colors.brown[300]!; // Bronze
      default:
        return Colors.blue;
    }
  }
}
