import 'package:flutter/material.dart';
import 'package:musix/views/each_playlist_view.dart';
import 'package:musix/views/favorites_view.dart';
import 'package:provider/provider.dart';
import '../Auth.dart';
import '../testClient.dart';

class ALLPlaylistView extends StatefulWidget {
  const ALLPlaylistView({super.key});

  @override
  State<ALLPlaylistView> createState() => _ALLPlaylistViewState();
}

class _ALLPlaylistViewState extends State<ALLPlaylistView> {
  List<Map<String, dynamic>> playlists = [];
  String? error;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPlaylists();
  }

  Future<void> loadPlaylists() async {
    try {
      final client = Provider.of<CommandClient>(context, listen: false);
      final result = await client.sendCommand("GetPlaylists");

      setState(() {
        playlists = List<Map<String, dynamic>>.from(result["playlists"]);
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  Future<void> createPlaylist(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    final client = Provider.of<CommandClient>(context, listen: false);

    final playlistName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("New Playlist"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Playlist name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.pop(context, controller.text.trim());
                }
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );

    if (playlistName == null || playlistName.isEmpty) return;

    try {
      final response = await client.sendCommand(
        "NewPlaylist",
        extraData: {"playlistName": playlistName},
      );

      if (response["status-code"] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Playlist created!")),
        );
        loadPlaylists();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to create playlist")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle:true,
        title: Text('P L A Y     L I S T S', style: TextStyle(fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary ),),
        backgroundColor:Theme.of(context).colorScheme.surface ,
      ),
          body:
          ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              var playlist = playlists[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                color: Theme.of(context).colorScheme.inversePrimary,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                  leading: Icon(
                    Icons.play_circle_outline,
                    size: 50,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(
                    playlist['title'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                  onTap: () async {
                    if(playlist['title']=="favorites"){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>FavoritesView()));
                    }
                    else{final client = Provider.of<CommandClient>(context, listen: false);
                    final auth = Provider.of<AuthProvider>(context, listen: false);
                    final response=await client.sendCommand("GetPlaylistSongs",username: auth.username??"NO", extraData: {"playlistName": playlist['title']});
                    List<dynamic> songIdsDynamic = [];
                    List<int> songIds = [];
                    if (response["status-code"] == 200) {
                      songIdsDynamic = response["songs"];
                      songIds = songIdsDynamic.whereType<int>().toList();
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SongsByIdsView(songIds: songIds, playlistName: playlist['title'],)));}}

                  },
                ),
              );
            },
          ),


        floatingActionButton: FloatingActionButton(onPressed: () {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        if(!auth.isAuthenticated){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("login to make playlists!")),
          );
        }else{
          createPlaylist(context);
        }
      },tooltip: 'Create a new playlist', child: Icon(Icons.add),),
    );
  }}
