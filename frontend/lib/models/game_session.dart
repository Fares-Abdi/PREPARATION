import 'package:firebase_database/firebase_database.dart';

enum GameState { waiting, starting, drawing, roundEnd, gameOver }

class Player {
  final String id;
  final String name;
  int score;
  bool isDrawing;

  Player({
    required this.id,
    required this.name,
    this.score = 0,
    this.isDrawing = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'score': score,
    'isDrawing': isDrawing,
  };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    id: json['id'],
    name: json['name'],
    score: json['score'] ?? 0,
    isDrawing: json['isDrawing'] ?? false,
  );
}

class GameSession {
  final String id;
  List<Player> players;
  GameState state;
  String? currentWord;
  int roundTime;
  int currentRound;
  int maxRounds;
  DateTime? roundStartTime;

  GameSession({
    required this.id,
    this.players = const [],
    this.state = GameState.waiting,
    this.currentWord,
    this.roundTime = 80,
    this.currentRound = 0,
    this.maxRounds = 3,
    this.roundStartTime,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'players': players.map((p) => p.toJson()).toList(),
    'state': state.toString(),
    'currentWord': currentWord,
    'roundTime': roundTime,
    'currentRound': currentRound,
    'maxRounds': maxRounds,
    'roundStartTime': roundStartTime?.millisecondsSinceEpoch,
  };

  factory GameSession.fromJson(Map<String, dynamic> json) => GameSession(
    id: json['id'],
    players: (json['players'] as List)
        .map((p) => Player.fromJson(Map<String, dynamic>.from(p)))
        .toList(),
    state: GameState.values.firstWhere(
      (e) => e.toString() == json['state'],
      orElse: () => GameState.waiting,
    ),
    currentWord: json['currentWord'],
    roundTime: json['roundTime'] ?? 80,
    currentRound: json['currentRound'] ?? 0,
    maxRounds: json['maxRounds'] ?? 3,
    roundStartTime: json['roundStartTime'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['roundStartTime'])
        : null,
  );

  static Future<GameSession> create({
    required String creatorId,
    required String creatorName,
  }) async {
    final ref = FirebaseDatabase.instance.ref().child('game_sessions').push();
    final session = GameSession(
      id: ref.key!,
      players: [
        Player(id: creatorId, name: creatorName, isDrawing: true),
      ],
    );
    
    await ref.set(session.toJson());
    return session;
  }
}
