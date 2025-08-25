import 'package:flutter/material.dart';
import 'package:musix/models/playlist_sqlite.dart';
import 'package:musix/views/song_view.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../view_models/song_view_model.dart';

class PlaylistDetailPage extends StatefulWidget {
  final int playlistId;
  final String playlistName;

  const PlaylistDetailPage({
    super.key,
    required this.playlistId,
    required this.playlistName,
  });

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> songs = [];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final ids = await PlaylistDB.instance.getSongIdsInPlaylist(widget.playlistId);

    bool hasPermission = await _audioQuery.permissionsStatus();
    if (!hasPermission) {
      await _audioQuery.permissionsRequest();
    }

    final allSongs = await _audioQuery.querySongs();
    final matchedSongs = allSongs.where((s) => ids.contains(s.id)).toList();

    setState(() {
      songs = matchedSongs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SongViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistName),
        centerTitle: true,
      ),
      body: songs.isEmpty
          ? const Center(child: Text("No songs in this playlist"))
          : ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return ListTile(
            onTap: () {
              viewModel.setSongs(songs);
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
              nullArtworkWidget: const Icon(Icons.music_note, size: 40),
            ),
            title: Text(song.title),
            subtitle: Text(song.artist ?? "Unknown Artist"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await PlaylistDB.instance.removeSongFromPlaylist(
                  widget.playlistId,
                  song.id,
                );
                _loadSongs();
              },
            ),
          );
        },
      ),
    );
  }
}
