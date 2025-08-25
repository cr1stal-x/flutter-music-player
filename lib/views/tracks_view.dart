import 'package:flutter/material.dart';
import 'package:musix/views/song_view.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../Auth.dart';
import '../testClient.dart';
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


  void _showAddToPlaylistDialog(BuildContext context, SongModel song) async {
    final client = Provider.of<CommandClient>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final playlistsResponse = await client.sendCommand(
      "GetPlaylists",
    );

    List<Map<String, dynamic>> playlists = [];
    if (playlistsResponse["status-code"] == 200) {
      playlists = List<Map<String, dynamic>>.from(playlistsResponse["playlists"]);
    }

    if (playlists.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You don't have any playlists yet.")),
      );
      return;
    }

    String? selectedPlaylist;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose a Playlist'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: double.minPositive,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: playlists.map((playlist) {
                    return RadioListTile<String>(
                      title: Text(playlist['title']),
                      value: playlist['title'],
                      groupValue: selectedPlaylist,
                      onChanged: (value) {
                        setState(() {
                          selectedPlaylist = value;
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (selectedPlaylist != null) {
                  final response = await client.sendCommand(
                    "AddSong",
                    username: auth.username ?? "NO",
                    extraData: {
                      "playlistName": selectedPlaylist,
                      "songId": song.id,
                    },
                  );

                  if (response["status-code"] == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Added ${song.title} to $selectedPlaylist")),
                    );
                  } else if (response["status-code"] == 404) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Playlist doesn't exist.")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: ${response["message"]}")),
                    );
                  }
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }


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
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'add_to_playlist') {
                    final auth = Provider.of<AuthProvider>(context, listen: false);
                    if(auth.isAuthenticated){
                      _showAddToPlaylistDialog(context, song);
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('login to your account to add songs to playlists.')),
                      );
                    }
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'add_to_playlist',
                    child: Text('Add to Playlist'),
                  ),
                ],
              ),
              onTap: () async {
                playlistProvider.setSongs(libraryVM.allSongs.map((s) => s.song).toList());
                await playlistProvider.setSong(index);
                await playlistProvider.play();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MusicPlayerScreen()),
                );
              },
            );

          },
        );
      },
    );
  }
}



