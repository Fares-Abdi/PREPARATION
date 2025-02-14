import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import '../models/game_session.dart';

class GameService {
  final _database = FirebaseDatabase.instance.ref();
  final _wordList = [
    'apple', 'banana', 'cat', 'dog', 'elephant',
    'flower', 'guitar', 'house', 'ice cream', 'jellyfish',
    // Add more words as needed
  ];

  Stream<GameSession> subscribeToGame(String gameId) {
    return _database
        .child('game_sessions')
        .child(gameId)
        .onValue
        .map((event) {
      if (event.snapshot.value == null) {
        throw Exception('Game session not found');
      }
      // Fix type casting
      final data = Map<String, dynamic>.from(event.snapshot.value as Map<Object?, Object?>);
      return GameSession.fromJson(data);
    });
  }

  Future<void> joinGame(String gameId, Player player) async {
    final gameRef = _database.child('game_sessions').child(gameId);
    
    await gameRef.runTransaction((Object? obj) {
      if (obj == null) return Transaction.abort();
      
      final game = GameSession.fromJson(Map<String, dynamic>.from(obj as Map));
      if (game.players.any((p) => p.id == player.id)) return Transaction.success(obj);
      
      game.players.add(player);
      return Transaction.success(game.toJson());
    });
  }

  Future<void> submitGuess(String gameId, String playerId, String guess) async {
    final gameRef = _database.child('game_sessions').child(gameId);
    final snapshot = await gameRef.get();
    
    if (!snapshot.exists) return;
    
    final game = GameSession.fromJson(
      Map<String, dynamic>.from(snapshot.value as Map));
    
    if (game.currentWord?.toLowerCase() == guess.toLowerCase()) {
      // Update player score
      final playerIndex = game.players.indexWhere((p) => p.id == playerId);
      if (playerIndex != -1) {
        game.players[playerIndex].score += 100;
        await gameRef.child('players/$playerIndex/score')
            .set(game.players[playerIndex].score);
      }
    }
  }

  Future<void> startNewRound(String gameId) async {
    final gameRef = _database.child('game_sessions').child(gameId);
    final word = _wordList[DateTime.now().millisecondsSinceEpoch % _wordList.length];
    
    await gameRef.update({
      'currentWord': word,
      'state': GameState.drawing.toString(),
      'roundStartTime': ServerValue.timestamp,
    });

    // Start round timer
    Timer(const Duration(seconds: 80), () {
      endRound(gameId);
    });
  }

  Future<void> endRound(String gameId) async {
    final gameRef = _database.child('game_sessions').child(gameId);
    final snapshot = await gameRef.get();
    
    if (!snapshot.exists) return;
    
    final game = GameSession.fromJson(
      Map<String, dynamic>.from(snapshot.value as Map));
    
    if (game.currentRound >= game.maxRounds) {
      await gameRef.update({
        'state': GameState.gameOver.toString(),
      });
    } else {
      // Rotate drawer role
      final currentDrawerIndex = 
          game.players.indexWhere((p) => p.isDrawing);
      final nextDrawerIndex = 
          (currentDrawerIndex + 1) % game.players.length;
      
      game.players[currentDrawerIndex].isDrawing = false;
      game.players[nextDrawerIndex].isDrawing = true;
      
      await gameRef.update({
        'state': GameState.roundEnd.toString(),
        'currentRound': game.currentRound + 1,
        'players': game.players.map((p) => p.toJson()).toList(),
      });
    }
  }

  Stream<List<GameSession>> getAvailableGames() {
    return _database
        .child('game_sessions')
        .orderByChild('state')
        .equalTo(GameState.waiting.toString())
        .onValue
        .map((event) {
      final games = <GameSession>[];
      if (event.snapshot.value != null) {
        // Fix type casting
        final gamesMap = Map<String, dynamic>.from(event.snapshot.value as Map<Object?, Object?>);
        gamesMap.forEach((key, value) {
          final gameData = Map<String, dynamic>.from(value as Map<Object?, Object?>);
          gameData['id'] = key;
          games.add(GameSession.fromJson(gameData));
        });
      }
      return games;
    });
  }
}
