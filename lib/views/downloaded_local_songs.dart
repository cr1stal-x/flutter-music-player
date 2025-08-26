import 'dart:io';
import 'package:flutter/material.dart';
import 'package:musix/views/server_player.dart';

class DownloadedServerSongs extends StatefulWidget {
  final String folderPath;

  const DownloadedServerSongs({super.key, required this.folderPath});

  @override
  State<DownloadedServerSongs> createState() => _DownloadedServerSongsState();
}

class _DownloadedServerSongsState extends State<DownloadedServerSongs> {
  late Future<List<LocalSong>> _songsFuture;

  @override
  void initState() {
    super.initState();
    _songsFuture = _loadSongs();
  }

  Future<List<LocalSong>> _loadSongs() async {
    final dir = Directory(widget.folderPath);
    if (await dir.exists()) {
      final files = dir.listSync().where((f) {
        return f.path.endsWith(".mp3") || f.path.endsWith(".m4a");
      }).toList();

      return convertToLocalSongs(files);
    }
    return [];
  }

  void _openPlayer(BuildContext context, LocalSong song) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LocalMusicPlayer(title: song.title, filePath: song.path,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Local Server Songs")),
      body: FutureBuilder<List<LocalSong>>(
        future: _songsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No songs found."));
          }
          final songs = snapshot.data!;
          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return ListTile(
                leading: const Icon(Icons.music_note),
                title: Text(song.title),
                subtitle: Text(song.artist),
                onTap: () => _openPlayer(context, song),
              );
            },
          );
        },
      ),
    );
  }
}
class LocalSong {
  final String path;
  final String title;
  final String artist;

  LocalSong({
    required this.path,
    required this.title,
    required this.artist,
  });
}

List<LocalSong> convertToLocalSongs(List<FileSystemEntity> files) {
  return files.map((file) {
    final name = file.uri.pathSegments.last;
    return LocalSong(
      path: file.path,
      title: name.split(".").first,
      artist: "Unknown Artist",
    );
  }).toList();
}

