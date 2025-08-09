import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../testClient.dart';
import 'ServerPlayer.dart';

class DownloadedSongsView extends StatefulWidget {
  const DownloadedSongsView({Key? key}) : super(key: key);

  @override
  State<DownloadedSongsView> createState() => _DownloadedSongsViewState();
}

class _DownloadedSongsViewState extends State<DownloadedSongsView> {
  List<Map<String, dynamic>> songs = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  Future<void> loadSongs() async {
    try {
      final client = Provider.of<CommandClient>(context, listen: false);
      final result = await client.sendCommand("GetDownloadedSongs");

      setState(() {
        songs = List<Map<String, dynamic>>.from(result["songs"]);
        Provider.of<DownloadedSongProvider>(context, listen: false).setSongs(songs);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Text("Error: $error"));
    final provider = Provider.of<DownloadedSongProvider>(context);
    final songs = provider.filteredSongs;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Downloaded Songs"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) => provider.search(query),
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          final title = song["title"]?.toString() ?? "Unknown Title";
          final artist = song["artist"]?.toString() ?? "Unknown Artist";

          return ListTile(
            title: Text(title),
            subtitle: Text(artist),
            trailing: IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                final safeTitle = title.replaceAll(RegExp(r'[\\/:*?"<>|\s]+'), '_');
                final filePath = "/storage/emulated/0/Download/Musix/$safeTitle.mp3";

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LocalMusicPlayer(
                      filePath: filePath,
                      title: title,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DownloadedSongProvider with ChangeNotifier {
  List<Map<String, dynamic>> _allSongs = [];
  List<Map<String, dynamic>> _filteredSongs = [];

  List<Map<String, dynamic>> get filteredSongs => _filteredSongs;

  void setSongs(List<Map<String, dynamic>> songs) {
    _allSongs = songs;
    _filteredSongs = songs;
    notifyListeners();
  }

  void search(String query) {
    if (query.isEmpty) {
      _filteredSongs = _allSongs;
    } else {
      _filteredSongs = _allSongs.where((song) {
        final title = (song['title'] ?? '').toString().toLowerCase();
        final artist = (song['artist'] ?? '').toString().toLowerCase();
        final q = query.toLowerCase();
        return title.contains(q) || artist.contains(q);
      }).toList();
    }

    notifyListeners();
  }
}
