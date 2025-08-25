import 'package:flutter/material.dart';
import 'package:musix/views/server_song_view.dart';
import 'package:provider/provider.dart';
import '../testClient.dart';

class SongsListView extends StatefulWidget {
  const SongsListView({Key? key, required this.category}) : super(key: key);
  final String? category;
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
      if(result['status-code']==200){
        List<Map<String, dynamic>> fetchedSongs = List<Map<String, dynamic>>.from(result["songs"]);

        if (widget.category != null) {
          fetchedSongs = fetchedSongs.where((song) {
            return (song['category'] ?? '').toString().toLowerCase() ==
                widget.category!.toLowerCase();
          }).toList();
        }

        setState(() {
          songs = fetchedSongs;
          Provider.of<SongProvider>(context, listen: false).setSongs(songs);
          isLoading = false;
        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No connection to the server.')),
        );
      }

    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if (error != null) return Center(child: Text("Error: $error", style: TextStyle(fontSize: 30),));
    final provider = Provider.of<SongProvider>(context);
    final songs = provider.filteredSongs;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Songs"),
        actions: [
          DropdownButton<SortOption>(
            value: provider.currentSort,
            underline: const SizedBox(),
            icon: const Icon(Icons.sort, color: Colors.black),
            dropdownColor: Theme.of(context).colorScheme.primary, 
            onChanged: (option) {
              if (option != null) provider.sortSongs(option);
            },
            items: const [
              DropdownMenuItem(
                value: SortOption.none,
                child: Text("None"),
              ),
              DropdownMenuItem(
                value: SortOption.rating,
                child: Text("Rating"),
              ),
              DropdownMenuItem(
                value: SortOption.ratingCount,
                child: Text("Rating Count"),
              ),
              DropdownMenuItem(
                value: SortOption.price,
                child: Text("Price"),
              ),
              DropdownMenuItem(
                  value: SortOption.number,
                  child: Text("dl number"),
              )
            ],
          ),
        ],
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          final title = song["title"]?.toString() ?? "Unknown Title";
          final artist = song["artist"]?.toString() ?? "Unknown Artist";

          return GestureDetector(
            child: ListTile(
              title: Text(title),
              subtitle: Text(artist),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Price
                  Text(
                    "\$${song['price']}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(width: 10),

                  // Rating stars
                  Row(
                    children: List.generate(5, (index) {
                      int starIndex = index + 1;
                      return Icon(
                        Icons.star,
                        size: 18,
                        color: starIndex <= (song['rating'] ?? 0)
                            ? Colors.amber
                            : Colors.grey[800],
                      );
                    }),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServerSongView(song: song),
                ),
              );
            },
          );

        },
      ),
    );
  }
}

enum SortOption { none, rating, ratingCount, price, number}

class SongProvider with ChangeNotifier {
  List<Map<String, dynamic>> _allSongs = [];
  List<Map<String, dynamic>> _filteredSongs = [];
  SortOption _currentSort = SortOption.none;

  List<Map<String, dynamic>> get filteredSongs => _filteredSongs;
  SortOption get currentSort => _currentSort;

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
    _applySort();
  }

  void sortSongs(SortOption option) {
    _currentSort = option;
    _applySort();
  }

  void _applySort() {
    switch (_currentSort) {
      case SortOption.rating:
        _filteredSongs.sort((a, b) =>
            ((b['rating'] ?? 0).toDouble()).compareTo((a['rating'] ?? 0).toDouble()));
        break;
      case SortOption.ratingCount:
        _filteredSongs.sort((a, b) =>
            ((b['rating_count'] ?? 0) as int).compareTo((a['rating_count'] ?? 0) as int));
        break;
      case SortOption.price:
        _filteredSongs.sort((a, b) =>
            ((a['price'] ?? 0).toDouble()).compareTo((b['price'] ?? 0).toDouble()));
        break;
      case SortOption.none:
        _filteredSongs = List.from(_allSongs);
        break;
      case SortOption.number:
        _filteredSongs.sort((a, b) =>
            ((b['download_time'] ?? 0) as int).compareTo((a['download_time'] ?? 0) as int));
        break;
    }
    notifyListeners();
  }
}
