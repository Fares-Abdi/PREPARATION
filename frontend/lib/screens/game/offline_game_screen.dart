import 'package:flutter/material.dart';
import '../../widgets/advanced_drawing_canvas.dart';

class OfflineGameScreen extends StatefulWidget {
  const OfflineGameScreen({Key? key}) : super(key: key);

  @override
  State<OfflineGameScreen> createState() => _OfflineGameScreenState();
}

class _OfflineGameScreenState extends State<OfflineGameScreen> {
  int _timeLeft = 60;
  int _score = 0;
  String _prompt = "Draw a cat";
  Color _currentColor = Colors.black;
  double _strokeWidth = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Time: $_timeLeft'),
            Text('Score: $_score'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Draw: $_prompt',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: AdvancedDrawingCanvas(
              initialColor: _currentColor,
              initialStrokeWidth: _strokeWidth,
            ),
          ),
          _buildColorPicker(),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildColorPicker() {
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Colors.black,
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
        ].map((color) => _buildColorButton(color)).toList(),
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () => setState(() => _currentColor = color),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: _currentColor == color ? Colors.white : Colors.black,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
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
