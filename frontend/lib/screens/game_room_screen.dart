import 'package:flutter/material.dart';
import '../widgets/advanced_drawing_canvas.dart';
import '../widgets/game_chat.dart';
import '../models/game_session.dart';
import '../services/game_service.dart';
import 'package:collection/collection.dart';

class GameRoomScreen extends StatefulWidget {
  final String gameId;
  final String userId;
  final String userName;

  const GameRoomScreen({
    Key? key,
    required this.gameId,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  State<GameRoomScreen> createState() => _GameRoomScreenState();
}

class _GameRoomScreenState extends State<GameRoomScreen> {
  final GameService _gameService = GameService();
  late Stream<GameSession> _gameStream;

  @override
  void initState() {
    super.initState();
    _gameStream = _gameService.subscribeToGame(widget.gameId);
  }

  Widget _buildGameContent(GameSession session) {
    final currentPlayer = session.players
        .firstWhere((p) => p.id == widget.userId);
    final isDrawing = currentPlayer.isDrawing;

    return Column(
      children: [
        // Game info bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Round ${session.currentRound + 1}/${session.maxRounds}'),
              if (session.roundStartTime != null)
                StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    final remaining = session.roundTime -
                        DateTime.now()
                            .difference(session.roundStartTime!)
                            .inSeconds;
                    return Text(
                      'Time: ${remaining > 0 ? remaining : 0}s',
                      style: TextStyle(
                        color: remaining < 10 ? Colors.red : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              Text('Score: ${currentPlayer.score}'),
            ],
          ),
        ),
        // Game area
        Expanded(
          child: Row(
            children: [
              // Drawing canvas
              Expanded(
                flex: 2,
                child: AdvancedDrawingCanvas(
                  userId: widget.userId,
                  gameSession: session,
                ),
              ),
              // Chat and scoreboard
              Expanded(
                child: Column(
                  children: [
                    // Scoreboard
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.grey.shade200,
                      child: Column(
                        children: [
                          const Text(
                            'Scoreboard',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          ...session.players
                              .map((player) => Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            if (player.isDrawing)
                                              const Icon(Icons.brush,
                                                  color: Colors.blue),
                                            Text(player.name),
                                          ],
                                        ),
                                        Text(player.score.toString()),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                    // Chat
                    Expanded(
                      child: GameChat(
                        gameSession: session,
                        userId: widget.userId,
                        userName: widget.userName,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scribble Game')),
      body: StreamBuilder<GameSession>(
        stream: _gameStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final session = snapshot.data!;
          if (session.state == GameState.gameOver) {
            // Show game over screen
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Game Over!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...session.players
                      .sorted((a, b) => b.score.compareTo(a.score))
                      .map((player) => Text(
                            '${player.name}: ${player.score} points',
                            style: const TextStyle(fontSize: 18),
                          )),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Back to Lobby'),
                  ),
                ],
              ),
            );
          }

          return _buildGameContent(session);
        },
      ),
    );
  }
}
