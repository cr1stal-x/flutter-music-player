import 'package:flutter/material.dart';
import 'package:musix/views/shop3_view.dart';
import 'dart:convert';
import 'dart:io';

class Shop2 extends StatefulWidget {
  final String category;
  final double credit;
  final bool isPremium;

  Shop2({Key? key, required this.category, this.credit = 10.0, this.isPremium = false}) : super(key: key);

  @override
  State<Shop2> createState() => _Shop2State();
}

class _Shop2State extends State<Shop2> {
  String selectedSortType = "rating";
  List<String> sortTypes = ["rating", "price", "downloads"];

  Map<String, dynamic> person = {
    'name': 'sara',
    'totalCredit': '10',
    'isPremium': 'normal',
  };

  List<Map<String, dynamic>> songs = [];
  bool loading = true;

  TextEditingController searchBox = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSongsFromServer();
  }

  Future<void> fetchSongsFromServer() async {
    try {
      Socket socket = await Socket.connect('127.0.0.1', 5000);
      socket.write(jsonEncode({'action': 'getSongs'}));
      socket.flush();

      socket.listen((data) {
        List<dynamic> response = jsonDecode(utf8.decode(data));
        setState(() {
          songs = response.map((s) => Map<String, dynamic>.from(s)).toList();
          loading = false;
        });
        socket.destroy();
      });
    } catch (e) {
      print('Error connecting to server: $e');
      setState(() {
        loading = false;
      });
    }
  }

  List<Map<String, dynamic>> filterSelect() {
    String search = searchBox.text.toLowerCase();
    return songs.where((s) => s['songName'].toString().toLowerCase().contains(search)).toList();
  }

  List<Map<String, dynamic>> sortSongs(String type, List<Map<String, dynamic>> list) {
    list.sort((a, b) {
      switch (type) {
        case 'rating':
          return (b['rating'] as double).compareTo(a['rating'] as double);
        case 'price':
          return (b['price'] as double).compareTo(a['price'] as double);
        case 'downloads':
          return (b['downloads'] as int).compareTo(a['downloads'] as int);
        default:
          return 0;
      }
    });
    return list;
  }

  Widget showSongsList(Map<String, dynamic> song) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          song['image'], //from server
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(song['songName'], style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('${song['singer']} - ${song['rating']}'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Shop3(
              selectedSong: song,
              selectedPerson: person,
              isPremium: widget.isPremium,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredSongs = sortSongs(selectedSortType, filterSelect());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text(widget.category, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchBox,
                    decoration: InputDecoration(
                      hintText: 'Search song name...',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: selectedSortType,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.primary,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    dropdownColor: Theme.of(context).colorScheme.primary,
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.white,
                    onChanged: (String? newValue) {
                      if (newValue != null) setState(() => selectedSortType = newValue);
                    },
                    items: sortTypes.map((String sortOption) {
                      return DropdownMenuItem<String>(
                        value: sortOption,
                        child: Text('Sort by $sortOption'),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredSongs.length,
                    itemBuilder: (context, index) => showSongsList(filteredSongs[index]),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    searchBox.dispose();
    super.dispose();
  }
}
