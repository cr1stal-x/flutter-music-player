CREATE DATABASE IF NOT EXISTS musix;

USE musix;

CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY auto_increment,
  username VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(50) NOT NULL,
  email VARCHAR(100),
  credit DOUBLE DEFAULT 5.00,
  isVip boolean DEFAULT false,
  profile_cover LONGTEXT
);

CREATE TABLE IF NOT EXISTS serverSongs (
  id INTEGER PRIMARY KEY auto_increment,
  title TEXT,
  artist TEXT,
  price DOUBLE DEFAULT 0.00,
  song_base64 LONGTEXT,
  cover_base64 LONGTEXT
);

CREATE TABLE IF NOT EXISTS playlists (
  id INTEGER PRIMARY KEY auto_increment,
  title TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS playlist_localSongs (
  playlist_id INTEGER,
  song_id INTEGER,
  PRIMARY KEY (playlist_id, song_id),
  FOREIGN KEY (playlist_id) REFERENCES playlists(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS comments (
  id INTEGER PRIMARY KEY auto_increment,
  user_id INTEGER NOT NULL,
  serverSong_id INTEGER NOT NULL,
  content TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (serverSong_id) REFERENCES serverSongs(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS downloaded_serverSongs (
  user_id INTEGER,
  song_id INTEGER,
  PRIMARY KEY (user_id, song_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (song_id) REFERENCES serverSongs(id) ON DELETE CASCADE
);




