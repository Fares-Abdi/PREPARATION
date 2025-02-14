import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/game_session.dart';

class GameChat extends StatefulWidget {
  final GameSession gameSession;
  final String userId;
  final String userName;

  const GameChat({
    Key? key,
    required this.gameSession,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  State<GameChat> createState() => _GameChatState();
}

class _GameChatState extends State<GameChat> {
  final _messageController = TextEditingController();
  final _chatRef = FirebaseDatabase.instance.ref().child('game_chats');
  
  void _sendMessage(String message) {
    if (message.isEmpty) return;
    
    final isDrawer = widget.gameSession.players
        .firstWhere((p) => p.id == widget.userId)
        .isDrawing;
    
    if (isDrawer) return; // Drawer can't send messages
    
    final isCorrectGuess = widget.gameSession.currentWord?.toLowerCase() == 
        message.toLowerCase();
    
    _chatRef.child(widget.gameSession.id).push().set({
      'userId': widget.userId,
      'userName': widget.userName,
      'message': isCorrectGuess ? '🎉 Correct guess!' : message,
      'timestamp': ServerValue.timestamp,
      'isCorrectGuess': isCorrectGuess,
    });

    if (isCorrectGuess) {
      // Update player score
      final playerRef = FirebaseDatabase.instance
          .ref()
          .child('game_sessions')
          .child(widget.gameSession.id)
          .child('players');
      
      playerRef.orderByChild('id').equalTo(widget.userId).once()
          .then((DatabaseEvent event) {
        if (event.snapshot.value != null) {
          final playerKey = (event.snapshot.value as Map).keys.first;
          playerRef.child(playerKey).child('score')
              .set(ServerValue.increment(100));
        }
      });
    }

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: _chatRef
                .child(widget.gameSession.id)
                .orderByChild('timestamp')
                .onValue,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(
                child: CircularProgressIndicator());

              final messages = <Map<String, dynamic>>[];
              if (snapshot.data?.snapshot.value != null) {
                final messagesMap = Map<String, dynamic>.from(
                    snapshot.data!.snapshot.value as Map);
                messages.addAll(messagesMap.values.cast<Map<String, dynamic>>());
                messages.sort((a, b) => 
                    (a['timestamp'] as int).compareTo(b['timestamp'] as int));
              }

              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isCurrentUser = message['userId'] == widget.userId;
                  final isCorrectGuess = message['isCorrectGuess'] ?? false;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: Align(
                      alignment: isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isCorrectGuess
                              ? Colors.green.shade100
                              : (isCurrentUser
                                  ? Colors.blue.shade100
                                  : Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['userName'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isCorrectGuess
                                    ? Colors.green
                                    : Colors.black87,
                              ),
                            ),
                            Text(message['message']),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        if (!widget.gameSession.players
            .firstWhere((p) => p.id == widget.userId)
            .isDrawing)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your guess...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
