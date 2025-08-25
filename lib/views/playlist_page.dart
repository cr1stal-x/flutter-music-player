import 'package:flutter/material.dart';
import 'package:musix/models/playlist_sqlite.dart';
import 'playlist_detail_page.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List<Map<String, dynamic>> playlists = [];

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    final data = await PlaylistDB.instance.getRawPlaylists();
    setState(() {
      playlists = data;
    });
  }

  Future<void> _createPlaylistDialog() async {
    final TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create Playlist"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter playlist name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  await PlaylistDB.instance.createPlaylist(name);
                  _loadPlaylists();
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Playlists")),
      body: ListView.builder(
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return ListTile(
            contentPadding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 10),
            leading: Icon(Icons.music_video, size: 60,),
            title: Text(playlist['name'], style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlaylistDetailPage(
                    playlistId: playlist['id'],
                    playlistName: playlist['name'],
                  ),
                ),
              );
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await PlaylistDB.instance.deletePlaylist(playlist['id'] as int);
                _loadPlaylists();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _createPlaylistDialog,
      ),
    );
  }
}
