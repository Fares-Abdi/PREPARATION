import 'package:flutter/material.dart';
import '../../widgets/advanced_drawing_canvas.dart';

class OnlineGameScreen extends StatefulWidget {
  const OnlineGameScreen({Key? key}) : super(key: key);

  @override
  State<OnlineGameScreen> createState() => _OnlineGameScreenState();
}

class _OnlineGameScreenState extends State<OnlineGameScreen> {
  bool _isSearchingMatch = true;
  String _opponent = "Player 2";
  int _myScore = 0;
  int _opponentScore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Match'),
      ),
      body: _isSearchingMatch ? _buildMatchmaking() : _buildGameInterface(),
    );
  }

  Widget _buildMatchmaking() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          const Text('Searching for opponent...'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildGameInterface() {
    return Column(
      children: [
        _buildScoreBoard(),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: AdvancedDrawingCanvas(
                  initialColor: Colors.black,
                  initialStrokeWidth: 5.0,
                ),
              ),
              const VerticalDivider(width: 2),
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Text('Opponent\'s Canvas'),
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildControlBar(),
      ],
    );
  }

  Widget _buildScoreBoard() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('You: $_myScore'),
          Text('$_opponent: $_opponentScore'),
        ],
      ),
    );
  }

  Widget _buildControlBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              // TODO: Implement clear canvas
            },
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement submit drawing
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
