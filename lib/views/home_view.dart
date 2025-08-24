import 'package:flutter/material.dart';
import 'package:musix/views/drawer.dart';
import 'package:musix/views/playlist_view.dart';
import 'package:musix/views/tracks_view.dart';
import 'package:provider/provider.dart';
import '../Auth.dart';
import '../testClient.dart';
import '../view_models/library_view_model.dart';
import 'downloaded_songs.dart';
class HomeView extends StatelessWidget {
  const HomeView({super.key});
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

      final response = await client.sendCommand("NewPlaylist",extraData: {"playlistName":playlistName});

      if (response["status-code"] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Playlist created!")),
        );
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
    return ChangeNotifierProvider(
        create: (_) => LibraryViewModel()..loadSongs(),
    child: Scaffold(
      appBar:AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle:true,
        title: Text('M U S I X', style: TextStyle(fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary ),),
      ) ,
      drawer: MyDrawer(),
    body: Consumer<LibraryViewModel>(
    builder: (context, vm, _) {
    if (vm.loading) return Center(child: CircularProgressIndicator());

    return ListView(
      children: [
        SizedBox(
        width: double.infinity,
        child: Container(
        padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      // border: Border.all(color: Theme.of(context).colorScheme.secondary),
      ),
      child: Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 30),
            FilledButton(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10),
                minimumSize: const Size(double.infinity, 120),
                backgroundColor:Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TracksView()),
                );
              },
              child: Column(
                children: const [
                  SizedBox(height: 6),
                  Icon(Icons.queue_music_outlined, size: 100),
                  Text('Tracks'),
                  SizedBox(height: 6),
                ],
              ),
            ),
            const SizedBox(height: 50),
            FilledButton(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10),
                minimumSize: const Size(double.infinity, 100),

                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                final auth = Provider.of<AuthProvider>(context, listen: false);
                if(!auth.isAuthenticated){
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('login to your account to see downloaded songs.')),
                  );
                return;}
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DownloadedSongsView()),
                );
              },
              child: Column(
                children: const [
                  SizedBox(height: 6),
                  Icon(Icons.album_rounded, size: 100),
                  Text('Server'),
                  SizedBox(height: 6),
                ],
              ),
            ),
            const SizedBox(height: 50),
            FilledButton(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10),
                minimumSize: const Size(double.maxFinite, 100),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                  final auth = Provider.of<AuthProvider>(context, listen: false);
                  if(!auth.isAuthenticated){
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('login to your account to make playlists.')),
                  );
                  return;}
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ALLPlaylistView()),
                );
              },
              child: Column(
                children: const [
                  SizedBox(height: 6),
                  Icon(Icons.playlist_add_outlined, size: 100),
                  Text('PlayLists'),
                  SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ],)))]
    );
}),

    ));
  }
}
