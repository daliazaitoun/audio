import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          IconButton(
            icon: assetsAudioPlayer.builderIsPlaying(
                builder: (context, isPlaying) {
                  return Icon(
                    isPlaying? Icons.pause : Icons.play_arrow,
                  );
                }),
            onPressed: () {
              assetsAudioPlayer.open(
                Audio("assets/1.mp3"),
              );
            },
          )
        ],
      ),
    );
  }
}
