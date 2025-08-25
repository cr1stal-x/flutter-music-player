import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PlaylistDB {
  static final PlaylistDB instance = PlaylistDB._init();
  static Database? _database;

  PlaylistDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("playlist.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE playlists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE playlist_songs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        playlist_id INTEGER NOT NULL,
        song_id INTEGER NOT NULL,
        FOREIGN KEY (playlist_id) REFERENCES playlists (id) ON DELETE CASCADE
      )
    ''');
  }


  Future<int> createPlaylist(String name) async {
    final db = await instance.database;
    return await db.insert('playlists', {'name': name});
  }

  Future<List<Map<String, dynamic>>> getRawPlaylists() async {
    final db = await database;
    return await db.query('playlists');
  }

  Future<int> deletePlaylist(int playlistId) async {
    final db = await database;
    return await db.delete('playlists', where: 'id = ?', whereArgs: [playlistId]);
  }


  Future<int> addSongToPlaylist(int playlistId, int songId) async {
    final db = await database;
    return await db.insert('playlist_songs', {
      'playlist_id': playlistId,
      'song_id': songId,
    });
  }

  Future<int> removeSongFromPlaylist(int playlistId, int songId) async {
    final db = await database;
    return await db.delete(
      'playlist_songs',
      where: 'playlist_id = ? AND song_id = ?',
      whereArgs: [playlistId, songId],
    );
  }

  Future<List<int>> getSongIdsInPlaylist(int playlistId) async {
    final db = await database;
    final result = await db.query(
      'playlist_songs',
      where: 'playlist_id = ?',
      whereArgs: [playlistId],
    );
    return result.map((map) => map['song_id'] as int).toList();
  }


  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
