import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:convert';
import 'package:lottie/lottie.dart';

class VoiceChatScreen extends StatefulWidget {
  final WebSocketChannel channel;
  final Function(List<Map<String, dynamic>>) onConversationComplete;

  const VoiceChatScreen({
    Key? key,
    required this.channel,
    required this.onConversationComplete,
  }) : super(key: key);

  @override
  _VoiceChatScreenState createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> with SingleTickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final audioPlayer = AudioPlayer();
  bool _isListening = false;
  bool _isProcessing = false;
  bool _isPlaying = false;
  List<Map<String, dynamic>> _conversation = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _setupAudioPlayerListeners();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _startListening(); // Auto-start listening
  }

  void _initializeSpeech() async {
    await _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
      onError: (error) => print('Speech error: $error'),
    );
  }

  void _setupAudioPlayerListeners() {
    audioPlayer.playerStateStream.listen((state) {
      setState(() => _isPlaying = state.playing);
      if (state.processingState == ProcessingState.completed) {
        _startListening();
        setState(() => _isProcessing = false);
      }
    });
  }

  void _startListening() {
    if (_isListening || _isProcessing) return;
    
    _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          final recognizedText = result.recognizedWords;
          if (recognizedText.isNotEmpty) {
            _conversation.add({
              'text': recognizedText,
              'isUser': true,
              'timestamp': DateTime.now().toIso8601String(),
            });

            widget.channel.sink.add(json.encode({
              'type': 'text',
              'user_id': '12345',
              'text': recognizedText,
            }));

            setState(() {
              _isListening = false;
              _isProcessing = true;
            });
          }
        }
      },
      listenFor: Duration(seconds: 10),
      cancelOnError: true,
      partialResults: false,
    );
    setState(() => _isListening = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            widget.onConversationComplete(_conversation);
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            if (_isListening)
              Lottie.asset(
                'assets/animation/voice_wave.json',
                width: 200,
                height: 200,
              )
            else if (_isProcessing || _isPlaying)
              Lottie.asset(
                'assets/animation/processing.json',
                width: 200,
                height: 200,
              )
            else
              Icon(Icons.mic, size: 100, color: Colors.white),
            SizedBox(height: 40),
            Text(
              _getStatusText(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText() {
    if (_isListening) return "Listening...";
    if (_isProcessing) return "Processing...";
    if (_isPlaying) return "Speaking...";
    return "Tap to speak";
  }

  @override
  void dispose() {
    _animationController.dispose();
    _speech.stop();
    audioPlayer.dispose();
    super.dispose();
  }
}
