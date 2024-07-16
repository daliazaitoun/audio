import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio/pages/playlist.dart';
import 'package:audio/widgets/sound_player_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final playlistEX = Playlist(
    audios: [
      Audio(
        'assets/1.mp3',
        metas: Metas(
          title: 'Song 1',
          artist: "Mohamed"
        ),
      ),
      Audio(
        'assets/2.mp3',
        metas: Metas(
          title: 'Song 2',
            artist: "Mona"
        ),
      ),
      Audio(
        'assets/3.mp3',
        metas: Metas(
          title: 'Song 3',
            artist: "mai"
        ),
      ),
    
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Audio Player'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) =>  PlaylistPage(playlist: playlistEX,)));
                },
                icon: Icon(Icons.playlist_add_check_circle_sharp))
          ],
        ),
        body: SoundPlayerWidget(
            playlist: playlistEX));
  }
}
