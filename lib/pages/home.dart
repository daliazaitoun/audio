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
  void initState() {
    initPlay();
    super.initState();
  }

  void initPlay() {
    assetsAudioPlayer.open(
      Playlist(audios: [
        Audio("assets/1.mp3", metas: Metas(title: "Song 1")),
        Audio("assets/2.mp3", metas: Metas(title: "Song 2")),
        Audio("assets/3.mp3", metas: Metas(title: "Song 3")),
      ]),
      autoStart: false,
    );
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: StreamBuilder(
                    stream: assetsAudioPlayer.realtimePlayingInfos,
                    builder: (context, snapShots) {
                      if (snapShots.connectionState ==
                          ConnectionState.waiting) {
                           return const Center(child: CircularProgressIndicator());
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            assetsAudioPlayer.getCurrentAudioTitle == ""
                                ? "Play a song"
                                : assetsAudioPlayer.getCurrentAudioTitle,
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               IconButton(
                                icon: Icon(Icons.skip_previous),
                                onPressed: () {
                                  assetsAudioPlayer.previous();
                                },
                              ),
                              getBtnWidget,
                               IconButton(
                                icon: Icon(Icons.skip_next),
                                onPressed: () {
                                  assetsAudioPlayer.next();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            '${convertSec(snapShots.data?.currentPosition.inSeconds ?? 0)} / ${convertSec(snapShots.data?.duration.inSeconds ?? 0)}',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          Slider(
                            value: snapShots.data?.currentPosition.inSeconds
                                    .toDouble() ??
                                0.0,
                            max:
                                snapShots.data?.duration.inSeconds.toDouble() ??
                                    0.0,
                            min: 0,
                            onChanged: (double value) {},
                          ),
                        ],
                      );
                    }),
              ),
            ),
        
          ],
        ),
      ),
    );
  }

  String convertSec(int seconds) {
    String minutes = (seconds ~/ 60).toString();
    String secondST = (seconds % 60).toString();
    return '${minutes.padLeft(2, '0')}:${secondST.padLeft(2, '0')}';
  }

  Widget get getBtnWidget =>
      assetsAudioPlayer.builderIsPlaying(builder: (ctx, isPlaying) {
        return FloatingActionButton.large(
          onPressed: () {
            if (isPlaying) {
              assetsAudioPlayer.pause();
            } else {
              assetsAudioPlayer.play();
            }
            setState(() {});
          },
          child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          shape: CircleBorder(),
        );
      });
}
