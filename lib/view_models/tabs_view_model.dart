import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class SongsViewModel extends ChangeNotifier {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  List<SongModel> _allSongs = [];
  List<SongModel> filteredSongs = [];

  String? _selectedArtist;
  String? _selectedAlbum;
  String? _selectedFolder;

  bool _loading = false;
  bool get loading => _loading;

  String? get selectedArtist => _selectedArtist;
  String? get selectedAlbum => _selectedAlbum;
  String? get selectedFolder => _selectedFolder;

  Future<void> loadSongs() async {
    _loading = true;
    notifyListeners();

    var status = await Permission.storage.request();
    if (!status.isGranted) {
      // Handle permission denied
      _loading = false;
      notifyListeners();
      return;
    }

    _allSongs = await _audioQuery.querySongs();
    filteredSongs = List.from(_allSongs);

    _loading = false;
    notifyListeners();
  }

  void setArtist(String? artist) {
    _selectedArtist = artist;
    _filterSongs();
  }

  void setAlbum(String? album) {
    _selectedAlbum = album;
    _filterSongs();
  }

  void setFolder(String? folder) {
    _selectedFolder = folder;
    _filterSongs();
  }

  void _filterSongs() {
    filteredSongs = _allSongs.where((song) {
      bool matchesArtist = _selectedArtist == null || _selectedArtist == "All" || (song.artist?.toLowerCase() == _selectedArtist?.toLowerCase());
      bool matchesAlbum = _selectedAlbum == null || _selectedAlbum == "All" || (song.album?.toLowerCase() == _selectedAlbum?.toLowerCase());
      bool matchesFolder = _selectedFolder == null || _selectedFolder == "All" || song.data.startsWith(_selectedFolder!);
      return matchesArtist && matchesAlbum && matchesFolder;
    }).toList();
    notifyListeners();
  }

  List<String> getArtists() {
    var artists = _allSongs.map((s) => s.artist ?? "Unknown Artist").toSet().toList();
    artists.sort();
    artists.insert(0, "All");
    return artists;
  }

  List<String> getAlbums() {
    var albums = _allSongs.map((s) => s.album ?? "Unknown Album").toSet().toList();
    albums.sort();
    albums.insert(0, "All");
    return albums;
  }

  List<String> getFolders() {
    var folders = _allSongs.map((s) {
      var path = s.data;
      return path.substring(0, path.lastIndexOf('/'));
    }).toSet().toList();
    folders.sort();
    folders.insert(0, "All");
    return folders;
  }
}
