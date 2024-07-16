import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class SongWidget extends StatefulWidget {
  final Audio audio;
  const SongWidget({required this.audio, super.key});

  @override
  State<SongWidget> createState() => _SongWidgetState();
}

class _SongWidgetState extends State<SongWidget> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    assetsAudioPlayer.open(widget.audio, autoStart: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: StreamBuilder(
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshots.data == null) {
            return const SizedBox.shrink();
          }
          return Text(
            '${convertSec(snapshots.data?.duration.inSeconds ?? 0)}',
          );
        },
        stream: assetsAudioPlayer.realtimePlayingInfos,
      ),
      leading: CircleAvatar(
        child: Center(
          child: Text(
              "${widget.audio.metas.artist?.split(" ").first[0].toUpperCase()}${widget.audio.metas.artist?.split(" ").last[0].toUpperCase()}"),
        ),
      ),
      title: Text(widget.audio.metas.title ?? "No Title"),
      subtitle: Text(widget.audio.metas.artist ?? "No Artist"),
      onTap: () {
        assetsAudioPlayer.play();
        
      },
    );
  }

  String convertSec(int seconds) {
    String minutes = (seconds ~/ 60).toString();
    String secondST = (seconds % 60).toString();
    return '${minutes.padLeft(2, '0')}:${secondST.padLeft(2, '0')}';
  }
}
