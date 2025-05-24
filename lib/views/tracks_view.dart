import 'package:flutter/material.dart';
import 'package:musix/views/song_view.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../view_models/library_view_model.dart';
import '../view_models/song_view_model.dart';


enum SortOption {
  modified,
  title,
  artist,
}
class TracksView extends StatelessWidget {
  const TracksView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LibraryViewModel()..loadSongs(),
      child: const TracksScreen(),
    );
  }
}

class TracksScreen extends StatelessWidget {
  const TracksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LibraryViewModel>(context);
    final playlistProvider = Provider.of<SongViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: TextField(
          controller: vm.searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => vm.search(vm.searchController.text),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildShuffleBar(context, vm),
          Expanded(child: _buildSongList(context, vm, playlistProvider)),
        ],
      ),
    );
  }

  Widget _buildShuffleBar(BuildContext context, LibraryViewModel vm) {
    return Row(
      children: [
        SizedBox(width: 15,),
        const Icon(Icons.play_circle),
        const SizedBox(width: 8),
        const Text("Shuffle Playback"),
        const Spacer(),
        PopupMenuButton<SortOption>(
          icon: const Icon(Icons.sort),
          onSelected: vm.sortSongs,
          itemBuilder: (_) => const [
            PopupMenuItem(value: SortOption.modified, child: Text("Last Modified")),
            PopupMenuItem(value: SortOption.title, child: Text("Title")),
            PopupMenuItem(value: SortOption.artist, child: Text("Artist")),
          ],
        )
      ],
    );
  }

  Widget _buildSongList(BuildContext context, LibraryViewModel vm, SongViewModel playlistProvider) {
    return Consumer<LibraryViewModel>(
      builder: (_, libraryVM, __) {
        final songs = libraryVM.allSongs;
        return ListView.builder(
          itemCount: songs.length,
          itemBuilder: (_, index) {
            final song = songs[index].song;
            return ListTile(
              title: Text(song.title),
              subtitle: Text(song.artist ?? "Unknown"),
              leading: QueryArtworkWidget(
                id: song.id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: Image.asset('assets/images/songs.png'),
              ),
              onTap: () async {
                playlistProvider.setSongs(libraryVM.allSongs.map((s) => s.song).toList());
                await playlistProvider.setSong(index);
                await playlistProvider.play();
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MusicPlayerScreen()));
              },
            );
          },
        );
      },
    );
  }
}



