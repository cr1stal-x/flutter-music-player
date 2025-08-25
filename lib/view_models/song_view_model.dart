import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SongViewModel extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> _songs = [];
  int _currentIndex = 0;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  Set<int> _favoriteIds = {};

  bool _isShuffle = false;
  LoopMode _loopMode = LoopMode.off;

  late final StreamSubscription<Duration> _positionSub;
  late final StreamSubscription<Duration?> _durationSub;

  bool get isPlaying => _player.playing;
  List<SongModel> get songs => _songs;
  int get currentIndex => _currentIndex;
  Duration get position => _position;
  Duration get duration => _duration;
  bool get isFavorite => _songs.isNotEmpty && _favoriteIds.contains(_songs[_currentIndex].id);
  bool get isShuffle => _isShuffle;
  LoopMode get loopMode => _loopMode;

  int _shufflePointer = 0;
  List<int> shuffledIndices = [];

  Future<void> init() async {
    await _checkPermissions();

    _songs = await _audioQuery.querySongs();
    if (_songs.isNotEmpty) {
      await setSong(0);
    }

    await _loadFavorites();

    _positionSub = _player.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    _durationSub = _player.durationStream.listen((dur) {
      _duration = dur ?? Duration.zero;
      notifyListeners();
    });

    notifyListeners();
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.audio.status;
    if (!status.isGranted) {
      final newStatus = await Permission.audio.request();
      if (!newStatus.isGranted) {
        if (kDebugMode) print("Audio permission denied");
        return;
      }
    }
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favorites') ?? [];
    _favoriteIds = favs.map(int.parse).toSet();
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', _favoriteIds.map((id) => id.toString()).toList());
  }

  Future<void> setSong(int index) async {
    if (index < 0 || index >= _songs.length) return;
    final song = _songs[index];
    if (song.uri == null) return;

    _currentIndex = index;
    await _player.setAudioSource(AudioSource.uri(Uri.parse(song.uri!)));
    notifyListeners();
  }

  Future<void> play() async {
    await _player.play();
    notifyListeners();
  }

  Future<void> pause() async {
    await _player.pause();
    notifyListeners();
  }

  Future<void> next() async {
    if (_isShuffle) {
      if (_shufflePointer >= shuffledIndices.length) {
        generateShuffleOrder();
      }
      final nextIndex = shuffledIndices[_shufflePointer];
      _shufflePointer++;
      await setSong(nextIndex);
    } else if (_currentIndex + 1 < _songs.length) {
      await setSong(_currentIndex + 1);
    } else if (_loopMode == LoopMode.all) {
      await setSong(0);
    } else {
      await pause();
      return;
    }
    await play();
  }

  Future<void> previous() async {
    if (_currentIndex - 1 >= 0) {
      await setSong(_currentIndex - 1);
    } else if (_loopMode == LoopMode.all) {
      await setSong(_songs.length - 1);
    }
    await play();
  }

  void seek(Duration position) {
    if (position > _duration) {
      position = _duration;
      next();
    } else if (position < Duration.zero) {
      position = Duration.zero;
    }
    _player.seek(position);
  }
  List<SongModel> get favoriteSongs =>
      _songs.where((song) => _favoriteIds.contains(song.id)).toList();

  Future<void> toggleFavorite() async {
    if (_songs.isEmpty) return;

    final songId = _songs[_currentIndex].id;
    if (_favoriteIds.contains(songId)) {
      _favoriteIds.remove(songId);
    } else {
      _favoriteIds.add(songId);
    }
    await _saveFavorites();
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    if (_isShuffle) {
      generateShuffleOrder();
    } else {
      shuffledIndices.clear();
      _shufflePointer = 0;
    }
    _player.setShuffleModeEnabled(_isShuffle);
    notifyListeners();
  }

  void generateShuffleOrder() {
    final indices = List<int>.generate(_songs.length, (i) => i);
    indices.remove(_currentIndex);
    indices.shuffle();
    shuffledIndices = [_currentIndex, ...indices];
    _shufflePointer = 1;
  }

  void cycleLoopMode() {
    _loopMode = LoopMode.values[(_loopMode.index + 1) % LoopMode.values.length];
    _player.setLoopMode(_loopMode);
    notifyListeners();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _positionSub.cancel();
    _durationSub.cancel();
    _player.dispose();
    super.dispose();
  }

  void setSongs(List<SongModel> newSongs) {
    _songs = newSongs;
    if (_isShuffle) {
      generateShuffleOrder();
    }
    notifyListeners();
  }
}
