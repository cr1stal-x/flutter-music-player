import 'package:flutter/material.dart';
import 'package:musix/Auth.dart';
import 'package:musix/views/song_view.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../testClient.dart';
import '../view_models/song_view_model.dart';

class SongsByIdsView extends StatefulWidget {
  final List<int> songIds;
  final playlistName;

  const SongsByIdsView({super.key, required this.songIds,required this.playlistName});

  @override
  State<SongsByIdsView> createState() => _SongsByIdsViewState();
}

class _SongsByIdsViewState extends State<SongsByIdsView> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> filteredSongs = [];

  @override
  void initState() {
    super.initState();
    loadSongsByIds();
  }

  Future<void> loadSongsByIds() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }

    List<SongModel> allSongs = await _audioQuery.querySongs();

    List<SongModel> songsFiltered = allSongs
        .where((song) => widget.songIds.contains(song.id))
        .toList();

    setState(() {
      filteredSongs = songsFiltered;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SongViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Songs (${filteredSongs.length})',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      body: filteredSongs.isEmpty
          ? const Center(child: Text('No songs found'))
          : ListView.builder(
        itemCount: filteredSongs.length,
        itemBuilder: (context, index) {
          final song = filteredSongs[index];
          return ListTile(
            onTap: () {
              viewModel.setSongs(filteredSongs);
              viewModel.setSong(index);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MusicPlayerScreen(),
                ),
              );
            },
            leading: QueryArtworkWidget(
              id: song.id,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: Container(
                width: 50,
                height: 50,
                color: Colors.grey.shade300,
                child: const Icon(Icons.music_note, size: 30),
              ),
            ),
            title: Text(song.title),
            subtitle: Text(song.artist ?? "Unknown Artist"),
            trailing: PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'delete') {
                  final client =
                  Provider.of<CommandClient>(context, listen: false);
                  final auth =
                  Provider.of<AuthProvider>(context, listen: false);
                  final response = await client.sendCommand(
                    "DeleteSong",
                    username: auth.username ?? "",
                    extraData: {
                      "songId": song.id,
                      "playlistName": widget.playlistName
                    },
                  );
                  if (response["status-code"] == 200) {
                    setState(() {
                      filteredSongs.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              '${song.title} deleted from playlist')),
                    );
                  }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Text("Delete from playlist"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
