import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';

class LocalMusicPlayer extends StatefulWidget {
  final String filePath;
  final String title;

  const LocalMusicPlayer({required this.filePath, required this.title, super.key});

  @override
  State<LocalMusicPlayer> createState() => _LocalMusicPlayerState();
}

class _LocalMusicPlayerState extends State<LocalMusicPlayer> {
  late AudioPlayer _player;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    if (!File(widget.filePath).existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File not found: ${widget.filePath}")),
      );
      Navigator.pop(context);
      return;
    }

    await _player.setFilePath(widget.filePath);

    _player.positionStream.listen((pos) {
      setState(() => _position = pos);
    });

    _player.durationStream.listen((dur) {
      setState(() => _duration = dur ?? Duration.zero);
    });

    _player.playerStateStream.listen((playerState) {
      setState(() {
        isPlaying = playerState.playing && playerState.processingState != ProcessingState.completed;
      });
    });
  }


  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(widget.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Slider(
            min: 0,
            max: _duration.inSeconds.toDouble(),
            value: _position.inSeconds.clamp(0, _duration.inSeconds).toDouble(),
            onChanged: (value) {
              _player.seek(Duration(seconds: value.toInt()));
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10),
                onPressed: () => _player.seek(_position - const Duration(seconds: 10)),
              ),
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                iconSize: 40,
                onPressed: () async {
                  if (_player.playing) {
                    await _player.pause();
                    setState(() => isPlaying = false);
                  } else {
                    await _player.play();
                    setState(() => isPlaying = true);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.forward_10),
                onPressed: () => _player.seek(_position + const Duration(seconds: 10)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
