import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio/widgets/song_widget.dart';
import 'package:flutter/material.dart';

class PlaylistPage extends StatefulWidget {
  final Playlist playlist;
  const PlaylistPage({required this.playlist,super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("PLaylist"),
        ),
        body: Column( children: [
                 Expanded(
                   child: ListView(
                    children: [
                      for(var song in widget.playlist.audios)
                     SongWidget(audio: song)
                    ],
                   ),
                 )
                ]));
  }
}
