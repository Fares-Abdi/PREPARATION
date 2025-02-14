import 'package:flutter/material.dart';
import '../models/game_session.dart';
import '../services/game_service.dart';
import 'game_room_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScribbleLobbyScreen extends StatelessWidget {
  final GameService _gameService = GameService();
  final user = FirebaseAuth.instance.currentUser;

  ScribbleLobbyScreen({Key? key}) : super(key: key);

  Future<void> _createGame(BuildContext context) async {
    final currentUser = user;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to create a game')),
      );
      return;
    }

    final session = await GameSession.create(
      creatorId: currentUser.uid,
      creatorName: currentUser.displayName ?? 'Player ${currentUser.uid.substring(0, 4)}',
    );

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameRoomScreen(
            gameId: session.id,
            userId: currentUser.uid,
            userName: currentUser.displayName ?? 'Player ${currentUser.uid.substring(0, 4)}',
          ),
        ),
      );
    }
  }

  Future<void> _joinGame(BuildContext context, String gameId) async {
    final currentUser = user;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to join a game')),
      );
      return;
    }

    await _gameService.joinGame(
      gameId,
      Player(
        id: currentUser.uid,
        name: currentUser.displayName ?? 'Player ${currentUser.uid.substring(0, 4)}',
      ),
    );

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameRoomScreen(
            gameId: gameId,
            userId: currentUser.uid,
            userName: currentUser.displayName ?? 'Player ${currentUser.uid.substring(0, 4)}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 32),
          const Text(
            'Scribble Game',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
            onPressed: () => _createGame(context),
            child: const Text(
              'Create New Game',
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Available Games',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: StreamBuilder<List<GameSession>>(
              stream: _gameService.getAvailableGames(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final games = snapshot.data!;
                if (games.isEmpty) {
                  return const Center(
                    child: Text('No games available.\nCreate a new one!'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    final game = games[index];
                    return Card(
                      child: ListTile(
                        title: Text('Game #${game.id.substring(0, 6)}'),
                        subtitle: Text('Players: ${game.players.length}'),
                        trailing: ElevatedButton(
                          onPressed: () => _joinGame(context, game.id),
                          child: const Text('Join'),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
