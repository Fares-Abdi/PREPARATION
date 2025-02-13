import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:convert';
import 'package:lottie/lottie.dart';

class VoiceChatScreen extends StatefulWidget {
  final WebSocketChannel channel;
  final Stream messageStream;
  final Function(List<Map<String, dynamic>>) onConversationComplete;

  const VoiceChatScreen({
    Key? key,
    required this.channel,
    required this.messageStream,
    required this.onConversationComplete,
  }) : super(key: key);

  @override
  _VoiceChatScreenState createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen>
    with SingleTickerProviderStateMixin {
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
    _setupWebSocketListener();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    // Start the conversation after a brief delay
    Future.delayed(Duration(milliseconds: 500), _startListening);
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

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _setupWebSocketListener() {
    widget.messageStream.listen((message) async {
      final data = json.decode(message);

      if (data['type'] == 'response') {
        // Add AI response to conversation
        _conversation.add({
          'text': data['text'],
          'isUser': false,
          'timestamp': DateTime.now().toIso8601String(),
        });

        // Wait for a brief moment before starting to listen again
        await Future.delayed(Duration(milliseconds: 500));
        if (mounted) {
          _startListening();
        }
      } else if (data['type'] == 'audio') {
        setState(() => _isProcessing = false);
        _stopListening();

        try {
          await audioPlayer.setUrl(data['audio_url']);
          setState(() => _isPlaying = true);
          await audioPlayer.play();
          // The next turn will be handled by audioPlayer listener
        } catch (e) {
          print('Error playing audio: $e');
          // If audio fails, start listening again
          if (mounted) {
            await Future.delayed(Duration(milliseconds: 500));
            _startListening();
          }
        }
      }
    });
  }

  void _setupAudioPlayerListeners() {
    audioPlayer.playerStateStream.listen((state) {
      setState(() => _isPlaying = state.playing);

      if (state.processingState == ProcessingState.completed) {
        setState(() => _isPlaying = false);
        // Start listening again after audio completes
        if (mounted) {
          Future.delayed(Duration(milliseconds: 500), _startListening);
        }
      }
    });
  }

  void _startListening() {
    if (_isListening || _isProcessing || _isPlaying) return;

    _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          final recognizedText = result.recognizedWords;
          if (recognizedText.isNotEmpty) {
            setState(() {
              _isListening = false;
              _isProcessing = true;
            });

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
      body: Stack(
        children: [
          // Background Animation with zoom effect
          Transform.scale(
            scale: 1.2, // Slightly zoom in the animation
            child: Positioned.fill(
              top: -50, // Extend beyond the top
              bottom: -50, // Extend beyond the bottom
              left: -50, // Extend beyond the left
              right: -50, // Extend beyond the right
              child: Lottie.asset(
                'assets/animation/Animation - 1739443672393.json',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 1.2,
                height: MediaQuery.of(context).size.height * 1.2,
              ),
            ),
          ),
          // Content
          Center(
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
                  Icon(
                    Icons.mic,
                    size: 100,
                    color: Colors.white.withOpacity(0.9),
                  ),
                SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
