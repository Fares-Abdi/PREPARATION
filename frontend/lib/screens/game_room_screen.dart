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

class _GameRoomScreenState extends State<GameRoomScreen> with SingleTickerProviderStateMixin {
  final GameService _gameService = GameService();
  late Stream<GameSession> _gameStream;
  late AnimationController _chatPanelController;
  late Animation<double> _chatPanelAnimation;
  bool _isChatVisible = false;

  @override
  void initState() {
    super.initState();
    _gameStream = _gameService.subscribeToGame(widget.gameId);
    
    _chatPanelController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _chatPanelAnimation = CurvedAnimation(
      parent: _chatPanelController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _chatPanelController.dispose();
    super.dispose();
  }

  void _toggleChat() {
    setState(() {
      _isChatVisible = !_isChatVisible;
      if (_isChatVisible) {
        _chatPanelController.forward();
      } else {
        _chatPanelController.reverse();
      }
    });
  }

  Widget _buildGameContent(GameSession session) {
    final currentPlayer = session.players.firstWhere((p) => p.id == widget.userId);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade50, Colors.purple.shade50],
            ),
          ),
          child: Column(
            children: [
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
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: AdvancedDrawingCanvas(
                            userId: widget.userId,
                            gameSession: session,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: _isChatVisible ? 310 : 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: _toggleChat,
            backgroundColor: Colors.deepPurple,
            child: Icon(
              _isChatVisible ? Icons.chat_bubble : Icons.chat_bubble_outline,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(_chatPanelAnimation),
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.deepPurple.shade100,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Players',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...session.players.map((player) => _buildPlayerTile(player)),
                      ],
                    ),
                  ),
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
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerTile(Player player) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: player.isDrawing ? Colors.deepPurple.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (player.isDrawing)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.brush, color: Colors.deepPurple, size: 16),
                ),
              Text(
                player.name,
                style: TextStyle(
                  color: player.isDrawing ? Colors.deepPurple : Colors.black87,
                  fontWeight: player.isDrawing ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          Text(
            player.score.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
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
