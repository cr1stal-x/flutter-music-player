import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:musix/view_models/song_view_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'box_view.dart';

class MusicPlayerScreen extends StatelessWidget {
  const MusicPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, size: 30),
                  ),
                  const Text('M U S I X', style: TextStyle(fontSize: 20)),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.menu, size: 30),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // Artwork + song info
              NeuBox(
                child: Selector<SongViewModel, SongModel?>(
                  selector: (context, vm) => vm.songs.isNotEmpty
                      ? vm.songs[vm.currentIndex]
                      : null,
                  builder: (context, song, _) {
                    if (song == null) return const SizedBox.shrink();

                    return Column(
                      children: [
                        Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey[300],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: QueryArtworkWidget(
                              key: ValueKey(song.id),
                              id: song.id,
                              type: ArtworkType.AUDIO,
                              artworkHeight: 250,
                              artworkWidth: 250,
                              nullArtworkWidget: Image.asset('assets/images/songs.png'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 25,
                                    width: 180, // adjust as needed
                                    child: Marquee(
                                      text: song.title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      scrollAxis: Axis.horizontal,
                                      blankSpace: 50.0,
                                      velocity: 30.0,
                                      pauseAfterRound: Duration(seconds: 1),
                                      startPadding: 10.0,
                                      accelerationDuration: Duration(seconds: 1),
                                      accelerationCurve: Curves.linear,
                                      decelerationDuration: Duration(milliseconds: 500),
                                      decelerationCurve: Curves.easeOut,
                                    ),
                                  ),
                                  Text(song.artist ?? "Unknown"),
                                ],
                              ),
                              Consumer<SongViewModel>(
                                builder: (context, vm, _) => GestureDetector(
                                  onDoubleTap: vm.toggleFavorite,
                                  child: Icon(
                                    vm.isFavorite ? Icons.favorite : Icons.favorite_outline,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 25),

              // Slider and loop/shuffle
              Consumer<SongViewModel>(
                builder: (context, vm, _) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(vm.formatTime(vm.position)),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: vm.toggleShuffle,
                                  icon: Icon(
                                    vm.isShuffle ? Icons.shuffle_on : Icons.shuffle,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  icon: Icon(
                                    vm.loopMode == LoopMode.one
                                        ? Icons.repeat_one
                                        : Icons.repeat,
                                    color: vm.loopMode == LoopMode.off
                                        ? Colors.grey
                                        : Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: vm.cycleLoopMode,
                                ),
                              ],
                            ),
                            Text(vm.formatTime(vm.duration)),
                          ],
                        ),
                      ),
                      Slider(
                        min: 0,
                        max: vm.duration.inSeconds.toDouble(),
                        value: vm.position.inSeconds.clamp(0, vm.duration.inSeconds).toDouble(),
                        onChanged: (newValue) {
                          vm.seek(Duration(seconds: newValue.toInt()));
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                        inactiveColor: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 10),

              // Playback controls
              Consumer<SongViewModel>(
                builder: (context, vm, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: vm.previous,
                          child: const NeuBox(child: Icon(Icons.skip_previous)),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () => vm.isPlaying ? vm.pause() : vm.play(),
                          child: NeuBox(
                            child: Icon(vm.isPlaying ? Icons.pause : Icons.play_arrow),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GestureDetector(
                          onTap: vm.next,
                          child: const NeuBox(child: Icon(Icons.skip_next)),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
