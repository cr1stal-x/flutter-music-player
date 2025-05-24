import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/modified_song_model.dart';
import '../views/tracks_view.dart';
class LibraryViewModel extends ChangeNotifier {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<ModifiedSong> _allSongs = [];
  List<ModifiedSong> _displayedSongs = [];
  final searchController = TextEditingController();

  bool _loading = false;
  SortOption _currentSort = SortOption.title;
  String _searchQuery = "";

  bool get loading => _loading;
  SortOption get currentSort => _currentSort;
  List<ModifiedSong> get allSongs => _displayedSongs;

  Future<void> loadSongs() async {
    _loading = true;
    notifyListeners();

    var permission = await Permission.storage.request();
    if (!permission.isGranted) {
      _loading = false;
      notifyListeners();
      return;
    }

    final rawSongs = await _audioQuery.querySongs();

    _allSongs = await Future.wait(rawSongs.map((s) async {
      DateTime modified;
      try {
        modified = await File(s.data).lastModified();
      } catch (_) {
        modified = DateTime(1000000000000);
      }
      return ModifiedSong(song: s, modified: modified);
    }));

    _updateDisplayedSongs(_allSongs);
    _loading = false;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query.toLowerCase();
    _updateDisplayedSongs(_getFilterSongs());
    notifyListeners();
  }

  void sortSongs(SortOption option) {
    _currentSort = option;
    _updateDisplayedSongs(_getSortedSongs());
    notifyListeners();
  }

  List<ModifiedSong> _getFilterSongs() {
    return _allSongs.where((s) {
      final title = s.song.title.toLowerCase();
      final artist = (s.song.artist ?? "").toLowerCase();
      return title.contains(_searchQuery) || artist.contains(_searchQuery);
    }).toList();
  }

  List<ModifiedSong> _getSortedSongs() {
    List<ModifiedSong> sorted = List.from(_allSongs);
    sorted.sort((a, b) {
      switch (_currentSort) {
        case SortOption.modified:
          return b.modified.compareTo(a.modified);
        case SortOption.artist:
          return (a.song.artist ?? "").toLowerCase()
              .compareTo((b.song.artist ?? "").toLowerCase());
        case SortOption.title:
        return a.song.title.toLowerCase()
              .compareTo(b.song.title.toLowerCase());
      }
    });
    return sorted;
  }

  void _updateDisplayedSongs(List<ModifiedSong> songs) {
    _displayedSongs = songs;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

