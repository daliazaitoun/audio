import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class SoundPlayerWidget extends StatefulWidget {
  final Playlist playlist;
  const SoundPlayerWidget({required this.playlist, super.key});

  @override
  State<SoundPlayerWidget> createState() => _SoundPlayerWidgetState();
}

class _SoundPlayerWidgetState extends State<SoundPlayerWidget> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  int valueEx = 0;
  double volumeEx = 1.0;
  double playSpeedEx = 1.0;

  @override
  void initState() {
    initPlay();
    super.initState();
  }

  void initPlay() {
    assetsAudioPlayer.open(
      widget.playlist,
      autoStart: false,
      loopMode: LoopMode.playlist
    );
    assetsAudioPlayer.playSpeed.listen((event) {
      playSpeedEx = event;
    });

    assetsAudioPlayer.volume.listen((event) {
      volumeEx = event;
    });
    assetsAudioPlayer.currentPosition.listen((event) {
      valueEx = event.inSeconds;
    });

    setState(() {});
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 600,
                height: 600,
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
                          return const Center(
                              child: CircularProgressIndicator());
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
                              '${convertSec(valueEx)} / ${convertSec(snapShots.data?.duration.inSeconds ?? 0)}',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Column(
                              children: [
                                Text(
                                  'Volume',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SegmentedButton(
                                        onSelectionChanged: (values) {
                                          volumeEx = values.first.toDouble();
                                          assetsAudioPlayer.setVolume(volumeEx);
                                          setState(() {});
                                        },
                                        segments: const [
                                          ButtonSegment(
                                            icon: Icon(Icons.volume_up),
                                            value: 1.0,
                                          ),
                                          ButtonSegment(
                                            icon: Icon(Icons.volume_down),
                                            value: 0.5,
                                          ),
                                          ButtonSegment(
                                            icon: Icon(Icons.volume_mute),
                                            value: 0,
                                          ),
                                        ],
                                        selected: {
                                          volumeEx
                                        }),
                                  ],
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Text(
                                  'Speed',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SegmentedButton(
                                        onSelectionChanged: (values) {
                                          ChangePlaySpeed(values);
                                        },
                                        segments: const [
                                          ButtonSegment(
                                            icon: Text('1X'),
                                            value: 1.0,
                                          ),
                                          ButtonSegment(
                                            icon: Text('2X'),
                                            value: 4.0,
                                          ),
                                          ButtonSegment(
                                            icon: Text('3X'),
                                            value: 8.0,
                                          ),
                                          ButtonSegment(
                                            icon: Text('4X'),
                                            value: 16.0,
                                          ),
                                        ],
                                        selected: {
                                          playSpeedEx
                                        }),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Slider(
                              value: valueEx.toDouble(),
                              max: snapShots.data?.duration.inSeconds
                                      .toDouble() ??
                                  0.0,
                              min: 0,
                              onChanged: (value) async {
                                setState(() {
                                  valueEx = value.toInt();
                                });
                              },
                              onChangeEnd: (value) async {
                                await assetsAudioPlayer
                                    .seek(Duration(seconds: value.toInt()));
                              },
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

  void ChangePlaySpeed(Set<double> values) {
    playSpeedEx = values.first.toDouble();
    assetsAudioPlayer.setPlaySpeed(playSpeedEx);
    setState(() {});
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
