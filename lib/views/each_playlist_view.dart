import 'package:flutter/material.dart';
import 'package:musix/views/song_view.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongsByIdsView extends StatefulWidget {
  final List<int> songIds;

  const SongsByIdsView({super.key, required this.songIds});

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Songs (${filteredSongs.length})', style: TextStyle(fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary ),),
      ),
      body: filteredSongs.isEmpty
          ? const Center(child: Text('No songs found'))
          : ListView.builder(
        itemCount: filteredSongs.length,
        itemBuilder: (context, index)  {
          final song = filteredSongs[index];
          return ListTile(
            onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context)=>MusicPlayerScreen()));},
            leading: QueryArtworkWidget(
              id: song.id,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: const Icon(Icons.music_note, size: 40),
            ),
            title: Text(song.title),
            subtitle: Text(song.artist ?? "Unknown Artist"),
          );
        },
      ),
    );
  }
}
