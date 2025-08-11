import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../view_models/song_view_model.dart';
import 'song_view.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SongViewModel>(context);
    final favoriteSongs = viewModel.favoriteSongs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Songs'),
      ),
      body: favoriteSongs.isEmpty
          ? const Center(child: Text("No favorite songs yet."))
          : ListView.builder(
        itemCount: favoriteSongs.length,
        itemBuilder: (context, index) {
          final song = favoriteSongs[index];
          return ListTile(
            title: Text(song.title),
            subtitle: Text(song.artist ?? "Unknown"),
            leading: QueryArtworkWidget(
              id: song.id,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: Image.asset('assets/images/songs.png'),
            ),
            onTap: () async {
              viewModel.setSongs(favoriteSongs);
              await viewModel.setSong(index);
              await viewModel.play();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MusicPlayerScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
