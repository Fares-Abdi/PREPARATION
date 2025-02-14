import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../widgets/advanced_drawing_canvas.dart';
import '../../models/drawing_session.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? currentSessionId;
  final String userId = 'user123'; // Replace with actual user ID from auth

  Future<void> _createNewSession() async {
    final sessionRef = FirebaseDatabase.instance.ref().child('drawing_sessions').push();
    final session = DrawingSession(
      id: sessionRef.key!,
      creatorId: userId,
      createdAt: DateTime.now(),
      points: [],
    );

    await sessionRef.set(session.toJson());
    setState(() => currentSessionId = session.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawing Board'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createNewSession,
          ),
        ],
      ),
      body: SafeArea(
        child: AdvancedDrawingCanvas(
          userId: userId,
          sessionId: currentSessionId,
          initialColor: Colors.black,
          initialStrokeWidth: 5.0,
        ),
      ),
    );
  }
}
