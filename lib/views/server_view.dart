import 'package:flutter/material.dart';
import 'package:musix/views/server_song_view.dart';
import 'package:provider/provider.dart';
import '../testClient.dart';

class SongsListView extends StatefulWidget {
  const SongsListView({Key? key}) : super(key: key);

  @override
  State<SongsListView> createState() => _SongsListViewState();
}

class _SongsListViewState extends State<SongsListView> {
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
      final result = await client.sendCommand("GetServerSongs");

      setState(() {
        songs = List<Map<String, dynamic>>.from(result["songs"]);
        Provider.of<SongProvider>(context, listen: false).setSongs(songs);
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
    // if (isLoading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Text("Error: $error"));
    final provider = Provider.of<SongProvider>(context);
    final songs = provider.filteredSongs;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Songs"),
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

          return GestureDetector(
            child: ListTile(
              title: Text(title),
              subtitle: Text(artist),
            ),
            onDoubleTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ServerSongView(song: song)));
            },
          );
        },
      ),
    );
  }
}

class SongProvider with ChangeNotifier {
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
